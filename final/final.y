%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void yyerror(const char *);


int yylex();
int get_vsp(char *);
int set_fun_va(char *i,int position);
int get_fun_vsp(char *);

enum Types {
    plu_op, sub_op, mut_op, div_op, mod_op,
    and_op, or_op, not_op, equ_op,gre_op,sma_op, num_no, 
    var_no,nothing, fun_no
};


typedef struct node{
    enum Types type;				//紀錄node是算式還是變數還是數字		
    char *name;						//如果是變數就紀錄名字
    int val;						//如果是數字就紀錄數值
    struct node *l;					// 左子樹
    struct node *r;					// 右子樹
}N;

N *CreateNode(enum Types NodeType,int V,char *Name);	//建造node
int EvalueTree(N *tree);								//把儲存的exp(node)按照DFS算出他的值
void put_paramater(N *tree);							//把fun_exp內function所使用的變數，代換成對應的parameter
void clear_fun_position();								//用完該function後，該變數的parameter就不用紀錄了，清空

typedef struct var{ 				//variable
    char* name;						//variable的名稱
    int val;						//數值，如果是function的話就是代表他的parameter_position
    struct node *tree;
}V;

V va[300];							//紀錄不同變數
int vsp=-1;							//變數位置的pointer

V fun_va[300];	  					//儲存function中variable name以及他在function的位置
int fun_vsp=0;	 				    //fun_va總共出現過幾次不同的variable
int fun_position=0;				    //在fun_va存下的variable name 對應在fun_ids 的位子
int para[300]={0}; 				    //儲存parameter
int pa_position=0; 					//按照順序儲存parameter的pointer
%}

%union{
    int ival;
    char* id;
	struct node *nd;
}

%start prog
%token <ival> NUMBER
%token <id> ID
%token PRINTNUM
%token PRINTBOOL
%token LAMBDA
%token IF
%token DEFINE
%token <ival> BOOL

%type <nd> exp variable num_op logical_op fun_exp fun_call if_exp fun_body
%type <nd> exps_a exps_e exps_mu exps_o exps_p
%type <nd> and_op or_op not_op
%type <nd> test_exp then_exp else_exp
%type <nd> divide modulus greater smaller equal plus minus multiply
%type <ival> param params fun_name

%%
prog: stmts             {;}
    ;
stmts
    :stmts stmt
    |stmt
    ;
stmt: exp                   {;}
    | def_stmt              {;}
    | print_stmt            {;}
    ;
    
print_stmt
    : '(' PRINTNUM exp ')' {printf("%d\n",EvalueTree($3));}
    | '(' PRINTBOOL exp ')'{
								int result=EvalueTree($3);
                                if(result==0)     printf("#f\n");
                                else if(result==1) printf("#t\n");
                            }
    ;
    
exp : BOOL                  {
								N *newNode=CreateNode(num_no,$1,"");
								$$=newNode;
							}
    | NUMBER                {
								N *newNode=CreateNode(num_no,$1,"");
								$$=newNode;
							}
    | variable              {$$=$1;}
    | num_op                {$$=$1;}
    | logical_op            {$$=$1;}
    | fun_exp               {$$=$1;}
    | fun_call              {$$=$1;}
    | if_exp                {$$=$1;}
    ;
    
num_op
    : plus                  {$$=$1;}
    | minus                 {$$=$1;}
    | multiply              {$$=$1;}
    | divide                {$$=$1;}
    | modulus               {$$=$1;}
    | greater               {$$=$1;}
    | smaller               {$$=$1;}
    | equal                 {$$=$1;}
    ;
    plus: '(' '+' exp exps_p ')'   {						
				N *newNode=CreateNode(plu_op,0,"");

				//l=exp 的 node r=exps 的 node					
				newNode->l=$3;
				newNode->r=$4;

				$$=newNode;
		}
        ;
        exps_p
            : exp               {$$=$1;}
            | exps_p exp        {
					N *newNode=CreateNode(plu_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				}
            ;
    minus
        : '(' '-' exp exp ')'   {
					N *newNode=CreateNode(sub_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				}
	  	;
    multiply
        : '(' '*' exp exps_mu ')'   {
					N *newNode=CreateNode(mut_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  	;
        exps_mu
            : exp                   {$$=$1;}
            | exps_mu exp           {
					N *newNode=CreateNode(mut_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				    }
            ;
    divide
        : '(' '/' exp exp ')'       {
					N *newNode=CreateNode(div_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  	;
    modulus
        : '(' 'm' exp exp ')'       {
					N *newNode=CreateNode(mod_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
		    		    }
	  	;
    greater
        : '(' '>' exp exp ')'       {
					N *newNode=CreateNode(gre_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  	;
    smaller
        : '(' '<' exp exp ')'       {
					N *newNode=CreateNode(sma_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
		    		    }
	  	;
    equal
        : '(' '=' exp exps_e ')'    {
					N *newNode=CreateNode(equ_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  	;
		exps_e
			: exp                   {$$=$1;}
			| exps_e exp            {
					N *newNode=CreateNode(equ_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
					}
			;
    
logical_op
    : and_op                        {$$=$1;}
    | or_op                         {$$=$1;}
    | not_op                        {$$=$1;}
    ;
    and_op
        : '(' 'a' exp exps_a ')'    {
					N *newNode=CreateNode(and_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
        ;
        exps_a
            : exp                   {$$=$1;}
            | exps_a exp            {
					N *newNode=CreateNode(and_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
			  	    }
            ;
        
    or_op
        : '(' 'o' exp exps_o ')'    {
					N *newNode=CreateNode(or_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
        ;
        exps_o
            : exp                   {$$=$1;}
            | exps_o exp            {
					N *newNode=CreateNode(or_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				    }
            ;
    not_op
        : '(' 'n' exp ')'           {
					N *newNode=CreateNode(not_op,0,"");
					newNode->l=$3;
					$$=newNode;
				    }
        ;

def_stmt
    : '(' DEFINE variable exp')'    {
					va[get_vsp($3->name)].val=EvalueTree($4);   	//把exp(node)的值算出來放到這個變數內
					va[get_vsp($3->name)].tree=$4; 		  			//把exp(node)儲存下來作為之後name function使用
				    }
    ;
    
variable
    : ID                            {
					int sp=get_vsp($1); 
					if(sp==-1){				  						// check有沒有這個ID的變數
						vsp++;
						va[vsp].name=$1;
						va[vsp].val=0;
					}
					N *newNode=CreateNode(var_no,0,$1);  			//創建一個variable的node
					$$=newNode;
				    }
    ;
    
fun_exp
    : '(' LAMBDA fun_ids fun_body ')'   {$$=$4;}
    ;
    
fun_ids
    :'('')'                             {;}
    |'(' ids ')'                        {;}
    ;
    ids : ID                        {
					fun_position++;
					set_fun_va($1,fun_position);	//將ID設一個FUN_VA的位子，並記錄他在ids的位子
					
				    } 
											
        | ids ID                    {
					fun_position++;
					set_fun_va($2,fun_position);	//將ID設一個FUN_VA的位子，並記錄他在ids的位子
					
				    } 
        ;
fun_body
    : exp                               {$$=$1;}
    ;
fun_call
    : '(' fun_exp')'                    {$$=$2;}
    | '(' fun_exp params ')'        {				//把EXP內的VARIBLE改掉成對應的parameter的數字
					put_paramater($2);
					$$=$2;
					clear_fun_position();
					pa_position=0;
					fun_position=0;
				    }
    | '(' fun_name')'                   {$$=va[$2].tree;}
    | '(' fun_name params ')'       {
					put_paramater(va[$2].tree);
					$$=va[$2].tree;
					clear_fun_position();
					pa_position=0;
					fun_position=0;
			  	    }
    ;
    params
        :param                      {
					pa_position++;
					para[pa_position]=$1;
					$$=pa_position;
					
				    }
	|params param               {
					pa_position++;
					para[pa_position]=$2;
					$$=pa_position;
					
				    }
        ;
        param
	    : exp                       {$$=EvalueTree($1);}	//獲取參數的值
            ;
			
fun_name
    : variable                          {$$=get_vsp($1->name);}
    ;

if_exp
    : '(' IF test_exp then_exp else_exp ')'  {
						if(EvalueTree($3)==0){
						    $$=$5;
						}
						else if(EvalueTree($3)==1){
					    	    $$=$4;
						}
					     }
    ;

test_exp
    : exp                       {$$=$1;}
    ;
then_exp
    : exp                       {$$=$1;}
    ;
else_exp
    : exp                       {$$=$1;}
    ;


%%

void yyerror(const char *message) {
	printf("syntax error");
}


int get_vsp(char *n){									//查詢變數的位置
	for(int i=0;i<=vsp;i++){
		if(strcmp(n,va[i].name)==0){return i;} // 找到變數，回傳其位置
	}
	return -1; // 沒有找到變數，回傳 -1
}

int set_fun_va(char *i,int position){					//新增或更新函數變數的位置
	int sp=get_fun_vsp(i);
	if(sp==0){											// check有沒有這個function
	    fun_vsp++;
	    fun_va[fun_vsp].name=i;
	    fun_va[fun_vsp].val=position;
	    return fun_vsp;
	}else{
	    fun_va[sp].val=position;
	    return sp;
	}
}

int get_fun_vsp(char *n){								//查詢函數變數的位置
	for(int i=1;i<=fun_vsp;i++){
	    if(strcmp(n,fun_va[i].name)==0){return i;}
	}
	return 0;
}

void put_paramater(N *tree){
    if(tree!=NULL){
        if(tree->type==var_no&&fun_va[get_fun_vsp(tree->name)].val!=0){ 				//是VARI的點又是funtion中的變數，就把它變成num_no的點，數值帶入parameter
    	    tree->type=num_no;
	    tree->val=para[fun_va[get_fun_vsp(tree->name)].val];
	}
	put_paramater(tree->l);
	put_paramater(tree->r);
    }
}

void clear_fun_position(){
    for(int i=1;i<=fun_vsp;i++){
        fun_va[i].val=0;
    }
}
void typeChecking(N* node, enum Types expectedType) {
    if (node->type != expectedType) {
        printf("Type Error: Expected %d but got %d\n", expectedType, node->type);
        exit(1);
    }
}
N* CreateNode(enum Types NodeType,int V,char *Name){
    N* NewNode = (N*) malloc(sizeof(N));
    NewNode->type = NodeType;
    NewNode->val = V;
    NewNode->name = Name;
    NewNode->l = NULL;
    NewNode->r = NULL;
    return NewNode;
}

int EvalueTree(N* tree){
    if(tree==NULL){return 0;}
    if(tree->type<=10 && tree->type>=0 ){ 		//如果是一個算式exp的node ，就算出來傳回去
	int left=0,right=0;
	left=EvalueTree(tree->l);
	right=EvalueTree(tree->r);


	switch(tree->type){		  //算出來
	case plu_op:	
	    return left+right;
	case sub_op:    
	    return left-right;
	case mut_op:    
	    return left*right;
	case div_op:    
	    return left/right;
	case mod_op:    
	    return left % right;
	case and_op:    
	    return left&&right;
	case or_op:    
	    return left||right;
	case not_op:
	    //printf("%d after not %d\n",left,!left);
	    return !left;
	case equ_op:    
	    return left == right;
	case gre_op:    
	    return left>right;
	case sma_op:    
	    return left<right;
	default:
	    return 0;
	}
  }
  else{	//如果這是 number or variable 的 node
      int sp=-1;
      switch(tree->type){
      case num_no:				//number，直接回傳
          return tree->val;
      case var_no:    			//variable，找他的值再回傳
          sp=get_vsp(tree->name);
	  	  return va[sp].val;
      default:
	  return 0;
      }
  }
}

int main (){
    fun_va[0].val=0; //初始化fun_va[0].val作為沒有被標示的標準
    yyparse();
    return 0;
}

