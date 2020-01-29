#!/bin/bash

rm compiler compiler.tab.h compiler.tab.c lex.yy.c

bison -d compiler.y

flex compiler.l

g++ compiler.tab.c lex.yy.c -o compiler -lm 
