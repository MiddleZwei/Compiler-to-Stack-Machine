%define parse.error verbose

%{
    /* C Declarations */
using namespace std;
// #include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <iostream>
#include<string.h>
// #include <iterator>
#include <map>
#include <vector>
#define YYDEBUG 1

extern int yylex();
extern int yyparse();
extern FILE *yyout;
extern FILE *yyin;
// extern const char* yytext;


void yyerror (const char *msg);

// int instruction = 0;
int linenum = 0;
int var_counter = 0;
void create_new_var();
void command(string msg);
void comment(const char * cmd, bool start);
void insert_var(string ident_name);
void increment_line();
int get_address(string id);

map<string, signed long long int> ds_vars;
vector<string> instruction_space = {};
// vector<string>::iterator instruction_it;

void output();
void instructions();
void insert_instruction(string msg);


void data();

void read(string id);
void print(string id);
void assign(string id1, string val);

void pop_adr();
void push_adr();
void push(signed long long int val);


%}

%union value {
  signed long long int num;
  const char *n;
}
/* Bison declarations */

/* Terminal: IDENT, nonterminal: num_expr */

%token NUM
%token <n> IDENT
%token ASSIGN
%token EXIT IF THEN ELSE WHILE DO PRINT READ AND OR NOT EQUAL SMALLER GREATER SMALLEREQ GREATEREQ NOTEQUAL TRUE FALSE LEFT RIGHT MINUS PLUS MUL DIV MOD _BEGIN END SEMICOLON

%type <n> num_expr
%type <n> rel GREATEREQ

%start program

%%
/* Grammar declarations */

program : instr     { output();}
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
         | IDENT                                                    { insert_var($1); }
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
    | GREATEREQ                                                      { $$ = $1; }
    | NOTEQUAL
    ;
bool_expr : TRUE
          | FALSE
          | LEFT bool_expr RIGHT
          | NOT bool_expr
          | bool_expr bool_op bool_expr
          | num_expr rel num_expr                                     {}
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

input_stat : READ IDENT                                         { 
                                                                  read($2); 
                                                                  cout << "read statement is read"; 
                                                                } 
           ;
output_stat : PRINT num_expr                                    { 
                                                                  print($2); 
                                                                  cout << "output statement is read"; 
                                                                }
            ;

while_stat : WHILE bool_expr DO simple_instr                    { comment("the while loop", false); }
           | DO simple_instr WHILE bool_expr                    { comment("the while loop", false); }
           ;
if_stat : IF bool_expr THEN simple_instr                        { comment("if statement", false); }
        | IF bool_expr THEN simple_instr ELSE simple_instr      { comment("if statement", false); }
        ;
assign_stat : IDENT ASSIGN num_expr                             {  cout << "assign statement is read"; }
            ;




%%

/* Additional C code */

void command(string msg){
    cout << "\t" << linenum << "\t" << msg;
    linenum++;
}
void comment(const char * cmd, bool start){
    if (start) {
        cout << "# " << cmd << " starts here";
    } else {
        cout << "# " << cmd << " ends here";
    }
}

void insert_var(string ident_name){
    ds_vars.insert(
            pair<string, signed long long int>(ident_name, 0) 
      );
}




void data(){
    cout << "\t" << "# variables ";

    // generate first comment
    auto pos1 = ds_vars.begin();
    for (auto it = pos1; it != ds_vars.end(); it++){
        cout << it->first << " ";
    }
    cout << "will be used" << endl;
    // -- end first comment


    // generate instruction
    const char msg[] = "DATA ";
    cout << "\t" << msg;
    auto pos2 = ds_vars.begin();
    for (auto it = pos2; it != ds_vars.end(); it++){
        cout << it->second << " ";
    } cout << endl;
    // -- end generating instruction
}



void read(string id){
    // logic
    // -- end logic

    // output
    string msg = "\t" + to_string(linenum) + "   READ \t\t # read a value for the variable " + id;
    increment_line();
    insert_instruction(msg);

    int adr = get_address(id);
    string msg2 = "\t" + to_string(linenum) + "   POP $"+ to_string(adr) +" \t\t # store it under the address "+ to_string(adr)  +", reserved for " + id;
    increment_line();
    insert_instruction(msg2);

    // -- end output
}
void print(string id){
    // logic
    // -- end logic

    // output
    int adr = get_address(id);
    string msg = "\t" + to_string(linenum) + "   PUSH $"+ to_string(adr) +" \t\t # push the value of " + id + " on the stack";
    increment_line();
    insert_instruction(msg);

    
    string msg2 = "\t" + to_string(linenum) + "   PRINT \t\t # print out the value of " + id;
    increment_line();
    insert_instruction(msg2);
    // -- end output
}

// FIXME stops when reaches this statement
void assign(string id1, auto val){
    // cout << typeid(val) << endl;


    // logic
    // -- end logic

    // output
    /*string msg = "\t" + to_string(linenum) + "   PUSH "+ val +" \t\t # push " + val + " on the stack";
    increment_line();
    insert_instruction(msg);

    int adr = get_address(id1);
    string msg2 = "\t" + to_string(linenum) + "   POP $"+ to_string(adr) +" \t\t # assign " + val + " to " + id1;
    increment_line();
    insert_instruction(msg2);*/

    // -- end output
    // cout << val;
}




void pop_adr(){
    string msg = "POP ";
    insert_instruction(msg);
}
void push_adr(){
    string msg = "PUSH ";
    insert_instruction(msg);
}
void push(signed long long int val){
    string msg = "PUSH " + val;
    insert_instruction(msg);
}




void output(){
  data();
  instructions();
}

void instructions(){
  // output everything from instruction space
  for (auto it = instruction_space.begin(); it != instruction_space.end(); it++){
    cout << *it;
    cout << endl;
  }
}
void insert_instruction(string msg){
  instruction_space.push_back(msg);
}
void increment_line(){
  linenum++;
}
int get_address(string id){
  int adr = -1;
  int counter = 0;
  map<string, signed long long int>::iterator it = ds_vars.begin();
  while(it != ds_vars.end()){
      string word = it->first;
      // FIXME if condition, always returns -1, can't find IDENTs and their order
      if (word.compare(id) == 0) {
        return counter;
      }
      else {
        counter++;
        it++;
      }
  }




  /*int adr = distance(ds_vars.begin(),ds_vars.find(id));

  cout << "dist " << id << " " << distance(ds_vars.begin(),ds_vars.find("i")) << endl; 
  cout << "dist " << id << " " << distance(ds_vars.begin(),ds_vars.find("j")) << endl; 
  map<string, signed long long int>::iterator it = m.find("i");
  map<string, signed long long int>::iterator it2 = m.find("j");

  cout << it-> << endl;*/

  return adr;
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
