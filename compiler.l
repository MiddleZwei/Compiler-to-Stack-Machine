%{
#include <string>
#include "node.h"
#include "parser.hpp"
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { }
%}

%%

"int"		return INT;
"long"		return LONG;
"signed"	return SIGNED;
"long"		return LONG;

"while"	return WHILE;
"if"	return IF;

"and"	return AND;
"or"	return OR;
"not"	return NOT;
"then"	return THEN;
"else"	return ELSE;

"do"	return DO;
"print"	return PRINT;
"read"	return READ;
"begin"	return BEGIN;
"end"	return END;
"exit"	return EXIT;

%%

