%error-verbose

%{
    /* C Declarations */
using namespace std;
// #include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <iostream>
#include<string.h>
#include <unordered_set>
#define YYDEBUG 1

extern int yylex();
extern int yyparse();
extern FILE *yyout;
extern FILE *yyin;
// extern const char* yytext;


void yyerror (const char *msg);

// int instruction = 0;
int linenum = 0;
// signed long long int vars[100];
int var_counter = 0;
void create_new_var();
void command(const char * msg);
void comment(const char * cmd, bool start);
void count_ident(string ident_name);
void data();
unordered_set<string> vars; 

const char *program_stack[100];
const char *memory_block[100];
const char *operating_stack[100];

void read(string id);
void pop_adr();

%}

%union value {
  signed long long int num;
  const char *n;
}
/* Bison declarations */

%token NUM
%token <n> IDENT
%token ASSIGN
%token EXIT IF THEN ELSE WHILE DO PRINT READ AND OR NOT EQUAL SMALLER GREATER SMALLEREQ GREATEREQ NOTEQUAL TRUE FALSE LEFT RIGHT MINUS PLUS MUL DIV MOD _BEGIN END SEMICOLON

%type <n> num_expr

%start program

%%
/* Grammar declarations */

program : instr     {data();}
        ;



num_op : PLUS
       | MINUS
       | DIV
       | MUL
       | MOD
       ;
num_expr : NUM 
         | MINUS NUM 
         | PLUS NUM 
         | IDENT                                                    { count_ident($1); }
         | num_expr num_op num_expr 
         | LEFT num_expr RIGHT
         ;


bool_op : AND 
        | OR
        | NOT
        ;
rel : EQUAL
    | SMALLER
    | SMALLEREQ
    | GREATER
    | GREATEREQ
    | NOTEQUAL
    ;
bool_expr : TRUE
          | FALSE
          | LEFT bool_expr RIGHT
          | NOT bool_expr
          | bool_expr bool_op bool_expr
          | num_expr rel num_expr
          ;


instr : instr simple_instr SEMICOLON
      | simple_instr SEMICOLON
      ;

simple_instr : assign_stat
             | if_stat
             | while_stat
             | _BEGIN instr END
             | output_stat
             | input_stat
             | EXIT
             ;

input_stat : READ IDENT                                         { read($2); cout << "read statement is read"; } 
           ;
output_stat : PRINT num_expr                                    { cout << "output statement is read"; }
            ;

while_stat : WHILE bool_expr DO simple_instr                    { comment("the while loop", false); }
           | DO simple_instr WHILE bool_expr                    { comment("the while loop", false); }
           ;
if_stat : IF bool_expr THEN simple_instr                        { comment("if statement", false); }
        | IF bool_expr THEN simple_instr ELSE simple_instr      { comment("if statement", false); }
        ;
assign_stat : IDENT ASSIGN num_expr                             { cout << "assign statement is read"; }
            ;




%%

/* Additional C code */

void command(const char * msg){
    cout << linenum << "     " << msg;
    linenum++;
}
void comment(const char * cmd, bool start){
    if (start) {
        cout << "# " << cmd << " starts here";
    } else {
        cout << "# " << cmd << " ends here";
    }
}

void count_ident(string ident_name){
    vars.insert(ident_name);
}




void data(){
    cout << "# variables ";
    auto pos = vars.cend();
    for (auto it = pos; it != vars.cbegin(); it--){
        cout << *it;
        cout << " and ";
    }
    cout << "will be used" << endl;


    const char msg[] = "DATA ";
    // command(msg);
    cout << msg;
    auto pos2 = vars.cend();
    for (auto it = pos2; it != vars.cbegin(); it--){
        cout << 0 << " ";
    }
}



void read(string id){
    const char msg[] = "READ";
    command(msg);
    cout << "# read a value for the variable " << id;
    cout << endl;
    pop_adr();
}



void pop_adr(){
    const char msg[] = "POP ";
    command(msg);

    cout << endl;
}





int main(int argc, char *argv[]) {
    yydebug = 0;
    yyin = stdin;
    yyparse();

    return 0;
}

void yyerror (const char *msg) {
    fprintf(stderr, "Parse error: %s\n", msg);
    exit(1);
}
