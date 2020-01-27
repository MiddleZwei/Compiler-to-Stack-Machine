all: compiler

compiler.tab.c compiler.tab.h:	compiler.y
	win_bison -d compiler.y

lex.yy.c: compiler.l compiler.tab.h
	win_flex compiler.l

compiler: lex.yy.c compiler.tab.c compiler.tab.h
	g++ -o compiler compiler.tab.c lex.yy.c

clean:
	del /f compiler compiler.tab.c lex.yy.c compiler.tab.h