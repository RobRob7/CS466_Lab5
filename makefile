### Lab 5 CS466
### CMINUS+
##	March 1, 2023
##	Robert J. Armendariz

# creates executable lab5
all:		lab5

# checks for lab5.l, lab5.y, runs lex on lab5.l which generates lex.yy.c,
# runs YACC on lab5.y which generates y.tab.h and y.tab.c; compiles lex.yy.c,
# y.tab.c, in conjunction with eachother and creates executable lab5
lab5:		lab5.l lab5.y
			lex lab5.l
			yacc -d lab5.y
			gcc lex.yy.c y.tab.c -o lab5
	
# remove lab5 executable
clean:
			rm -f lab5	