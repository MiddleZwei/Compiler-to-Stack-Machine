/* Definitions */


%{
        /* C code to be copied verbatim */
// #include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include "compiler.tab.h"
#define YY_DECL int yylex()

%}

/* %option noyywrap */

%%

"read"      {           return READ;            }
"begin"     {           return _BEGIN;           }
"end"       {           return END;             }
"print"     {           return PRINT;           }
"exit"      {           return EXIT;            }
"if"        {           return IF;              }
"then"      {           return THEN;            }
"else"      {           return ELSE;            }
"while"     {           return WHILE;           }
"do"        {           return DO;              }

"and"       {           return AND;             }
"or"        {           return OR;              }
"not"       {           return NOT;             }

"="         {           return EQUAL;           }
"<"         {           return SMALLER;         }
">"         {           return GREATER;         }
"<="        {           return SMALLEREQ;       }
">="        {           yylval.n=strdup(yytext); return GREATEREQ;       }
"<>"        {           return NOTEQUAL;        }
"true"      {           return TRUE;            }
"false"     {           return FALSE;           }
"("         {           return LEFT;            }
")"         {           return RIGHT;           }


[-]?[0-9]+  {           yylval.num = atoi(yytext); return NUM;}
[a-zA-Z][a-zA-Z0-9]* {  yylval.n=strdup(yytext); return IDENT;}
":="        {           return ASSIGN;          }
"#".*       {           /* DO NOTHING */        }
";"         {           return SEMICOLON;       }

"+"         {           return PLUS;            }
"-"         {           return MINUS;           }
"*"         {           return MUL;             }
"/"         {           return DIV;             }
"%"         {           return MOD;             }



%%

/* User code */

int yywrap(void){
    printf("EOF\n");
    return 1;
}