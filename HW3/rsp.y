%{
#include <stdio.h>
#define STACK_SIZE 20

int yylex();
void yyerror(const char* message);
struct stack {
int data[STACK_SIZE];
int top;
};

typedef struct stack stack_t;
stack_t stack;
int train, cnt=1;
int is_empty(); // to check if the stack is empty
void push(int i);
int pop();
void dump(); // to dump (or print) all the data in stack

%}


%union{
    double dval;
}

%token<dval> NUMBER 

%%

program : lines{ 
                if(top == 0)
                    printf("%.1f\n", peek());
                else
                    yyerror();
            }
        ;


lines : line lines
        | line
        ;
    
line : numbers
numbers  : numbers number
        | number
        ;

number : NUMBER { 
                if($1!=0 && $1<cnt){
                    printf("Error: Impossible to rearrange");
                    printf("There is no any train in the holding track");
                }
                else if($1==0){
                    if(is_empty()){
                        printf("Success");
                        return 0;
                    }
                    else{
                        printf("Error: There is still existing trains in the holding track\n");
                        dump();
                    }
                }
                else if($1==cnt){
                    printf("Train %d passing through", cnt);
                    cnt++;
                }
                else{
                    printf("Push train %d to holding track", cnt);
                    push(cnt);
                    cnt++;
                } 
            }
        ;
%%


int is_empty(){
    return top == -1;
}

void push(double number){
    stack[++top] = number;
}

double pop(){
    if(is_empty()){
        yyerror();
        exit(0);
    }
    return stack[top--];
}

double peek(){
    if(is_empty()){
        yyerror();
        exit(0);
    }
    return stack[top];
}

void dump(){
    stack.clean();
}


void yyerror(){
    printf("Error: Impossible to rearrange\n");
    printf("There is no any train in the holding track\n");
}

int main(){
    yyparse();

    return 0;
}