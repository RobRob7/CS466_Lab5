### Lab 4 CS466
### LEX and YACC program with symtable.c/symtable.h files that 
##	February 21, 2023
##	Robert J. Armendariz

# creates executable lab4
all:		lab4

# checks for lab4.l, lab4.y, symtable.c, and symtable.h, runs lex on lab4.l which generates lex.yy.c,
# runs YACC on lab4.y which generates y.tab.h and y.tab.c; compiles lex.yy.c,
# y.tab.c, and symtable.c in conjunction with eachother and creates executable lab4
lab4:		lab4.l lab4.y symtable.c symtable.h
			lex lab4.l
			yacc -d lab4.y
			gcc lex.yy.c y.tab.c symtable.c -o lab4
	
# remove lab4 executable
clean:
			rm -f lab4		