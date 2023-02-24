%{
  /*       Robert J. Armendariz
           Lab 5 -- Cminus into LEX and YACC
           March 1, 2023
		   Implementing CMINUS+ EBNF and translating it into YACC and LEX directives

		   Changes Made:
           > 
  */


	/* begin specs */
#include <stdio.h>
#include <ctype.h>

int yylex();

// external variables coming from lab5.l (LEX)
extern int mydebug;
extern int lineno;

void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("YACC PARSE ERROR: %s on line %d\n", s, lineno);
}

%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */

// allows LEX to return int or char*
%union {
	int value;
	char* string;
}

%start Program

// define each multi-varied token
%token <value> T_NUM
%token  <string> T_ID
%token T_INT
%token T_VOID
%token T_IF
%token T_ELSE
%token T_WHILE
%token T_RETURN
%token T_READ
%token T_WRITE
%token T_LE
%token T_LT
%token T_GT
%token T_GE
%token T_EQ
%token T_NE
%token T_ADD
%token T_MINUS
%token T_MULT
%token T_DIV
%token T_STRING

%%	/* end specs, begin rules */

Program : Declaration_List
		;

Declaration_List : Declaration
				 | Declaration Declaration_List
				 ;

Declaration : Var_Declaration
			| Fun_Declaration
			;

Var_Declaration : Type_Specifier Var_List ';'
				;

Var_List : T_ID	{ printf("Var_List ID is %s\n", $1); }
		 | T_ID '[' T_NUM ']' { printf("Var_List ID is %s\n", $1); }
		 | T_ID ',' Var_List { printf("Var_List ID is %s\n", $1); }
		 | T_ID '[' T_NUM ']' ',' Var_List { printf("Var_List ID is %s\n", $1); }
		 ;

Type_Specifier : T_INT
			   | T_VOID
			   ;

Fun_Declaration : Type_Specifier T_ID '(' Params ')' Compound_Stmt
				;

Params : T_VOID
	   | Param_List
	   ;

Param_List : Param 
		   | Param ',' Param
		   ;

Param : Type_Specifier T_ID
	  | Type_Specifier T_ID '[' ']'
	  ;

Compound_Stmt : /* empty */
			  | Local_Declarations Statement_List Compound_Stmt
			  ;
			
Local_Declarations : /* empty */
				   | Var_Declaration Local_Declarations
				   ;

Statement_List : /* empty */
			   | Statement Statement_List
			   ;

Statement : Expression_Stmt
		  | Compound_Stmt
		  | Selection_Stmt
		  | Iteration_Stmt
		  | Assignment_Stmt
		  | Return_Stmt
		  | Read_Stmt
		  | Write_Stmt
		  ;

Expression_Stmt : Expression ';'
				| ';'
				;

Selection_Stmt : T_IF '(' Expression ')' Statement
			   | T_IF '(' Expression ')' Statement T_ELSE Statement
			   ;

Iteration_Stmt : T_WHILE '(' Expression ')' Statement
			   ;

Return_Stmt : T_RETURN
			| T_RETURN Expression
			;

Read_Stmt : T_READ Var ';'
		  ;

Write_Stmt : T_WRITE Expression ';'
		   | T_WRITE T_STRING ';'
		   ;

Assignment_Stmt : Var '=' Simple_Expression
				;

Var : T_ID
	| T_ID '[' Expression ']'
	;

Expression : Simple_Expression
		   ;

Simple_Expression : Additive_Expression
			      | Additive_Expression Relop Additive_Expression
				  ;
			
Relop : T_LE
      | T_LT
	  | T_GT
	  | T_GE
	  | T_EQ
	  | T_NE
	  ;

Additive_Expression : Term
					| Term Addop Additive_Expression
					;

Addop : T_ADD
	  | T_MINUS
	  ;

Term : Factor
	 | Factor Multop Term
	 ;

Multop : T_MULT
	   | T_DIV
	   ;

Factor : '(' Expression ')' 
	   | T_NUM
	   | Var
	   | Call
	   | '-'Factor
	   ;

Call : T_ID '(' Args ')'
	 ;

Args : Arg_List
	 | /* empty */
	 ;

Arg_List : Expression
		 | Expression ',' Arg_List
		 ;

%%	/* end of rules, start of program */

int main()
{ 
	yyparse();
}