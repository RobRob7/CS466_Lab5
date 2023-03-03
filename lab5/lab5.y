%{
  /*       Robert J. Armendariz
           Lab 5 -- Cminus into LEX and YACC
           March 1, 2023
		   CMINUS Extended BNF YACC Implementation

		   
		   This YACC program utilizes the tokens returned from LEX and implements the 
		   extended BNF grammar for C Minus (check for proper syntax) from the PDF supplied
		   by Dr. Cooper. There is an additional syntax check for function prototypes.
		   Prints out 'T_ID' anywhere we see 'T_ID'

		   Changes Made:
           > removed all occurrences of previous labs that are not important (symbol table, reg, MAX, calculator functionality)
		   > define all tokens with specified names being returned from lab5.l
		   > implement extended BNF grammar for CMINUS
		   > define external int variables "mydebug", "lineno" from lab5.l
		   > all Non Terminals are Camel Case
		   > everywhere there is T_ID, the name of the variable is printed out
		   > GRAD PORTION: implemented grammar for function prototype

      SOURCE FROM SHAUN COOPER
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

// allows LEX to return int or char*
%union {
	int value;
	char* string;
}

// start symbol
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
			| Fun_Declaration_Proto
			;

Var_Declaration : Type_Specifier Var_List ';'
				;

Var_List : T_ID	{ printf("Var_LIST with value %s\n", $1); }
		 | T_ID '[' T_NUM ']' { printf("Var_LIST with value %s\n", $1); }
		 | T_ID ',' Var_List { printf("Var_LIST with value %s\n", $1); }
		 | T_ID '[' T_NUM ']' ',' Var_List { printf("Var_LIST with value %s\n", $1); }
		 ;

Type_Specifier : T_INT
			   | T_VOID
			   ;

Fun_Declaration : Type_Specifier T_ID '(' Params ')' Compound_Stmt { printf("FunDec with value %s\n", $2); }
				;

Fun_Declaration_Proto : Type_Specifier T_ID '(' Params ')' ';' { printf("FunPro with value %s\n", $2); }
					  ;

Params : T_VOID
	   | Param_List
	   ;

Param_List : Param 
		   | Param ',' Param_List
		   ;

Param : Type_Specifier T_ID { printf("PARAM with value %s\n", $2); }
	  | Type_Specifier T_ID '[' ']' { printf("PARAM with value %s\n", $2); }
	  ;

Compound_Stmt : '{' Local_Declarations Statement_List '}'
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

Return_Stmt : T_RETURN ';'
			| T_RETURN Expression ';'
			;

Read_Stmt : T_READ Var ';'
		  ;

Write_Stmt : T_WRITE Expression ';'
		   | T_WRITE T_STRING ';'
		   ;

Assignment_Stmt : Var '=' Simple_Expression ';'
				;

Var : T_ID { printf("Var with value %s\n", $1); }
	| T_ID '[' Expression ']' { printf("Var with value %s\n", $1); }
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
					| Additive_Expression Addop Term
					;

Addop : T_ADD
	  | T_MINUS
	  ;

Term : Factor
	 | Term Multop Factor
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

Call : T_ID '(' Args ')' { printf("CALL with value %s\n", $1); }
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