#!/bin/bash

rm compiler.tab.h compiler.tab.c lex.yy.c

bison -t -d compiler.y --debug 

flex --debug compiler.l

g++ compiler.tab.c lex.yy.c -o compiler -lm 
