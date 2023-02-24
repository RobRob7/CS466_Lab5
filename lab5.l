%{
  /*       Robert J. Armendariz
           Lab 5 -- Cminus into LEX and YACC
           March 1, 2023
           Implementing CMINUS+ EBNF and translating it into YACC and LEX directives

           Changes Made:
           > 
  */

// debug variable (0 for no debug statements, 1 for them to display)
int mydebug = 0;

// variable keeps track of line number
int lineno = 1;

#include "y.tab.h"
%}


%% /* end of definitions section, begin rules section */
int       { return(T_INT); }
void      { return(T_VOID); }
if        { return(T_IF); }
else      { return(T_ELSE); }
while     { return(T_WHILE); }
return    { return(T_RETURN); }
read      { return(T_READ); }
write     { return(T_WRITE); }
"<="      { return(T_LE); }
"<"       { return(T_LT); }
">"       { return(T_GT); }
">="      { return(T_GE); }
"=="      { return(T_EQ); }
"!="      { return(T_NE); }
"+"       { return(T_ADD); }
"-"       { return(T_MINUS); }
"*"       { return(T_MULT); }
"/"       { return(T_DIV); }
\".*\"    { return(T_STRING); }


[a-zA-Z][a-zA-Z0-9_]*		{ if (mydebug){
                            fprintf(stderr,"Letter found\n");
                          }
                          // use strdup() to copy yytext to yylval.string
                          yylval.string=strdup(yytext);
                          return(T_ID);
                        }

[0-9][0-9]*	{ if (mydebug){
                fprintf(stderr,"Digit found\n");
              } 
              // INTEGER rule now factors in ASCII to Integer conversion for yylval.value
              yylval.value=atoi((const char *)yytext);

              // return INTEGER token
              return(T_NUM);
            }
                
[ \t]		{ if (mydebug){
            // whitespace is found
            fprintf(stderr,"Whitespace found\n");
          }
        }

[=\-+*/%&|();,{}[]] 	{ if (mydebug){
                    fprintf(stderr,"return a token %c\n",*yytext); /* incorporated '(' and ')' into possible characters to return as token */
                  }
                  return (*yytext);
                }

\n 		{ if (mydebug){
          fprintf(stderr,"cariage return %c\n",*yytext);
        }
        // increment out line counter once newline is seen
        lineno++;
      }

"//".*  { /* consumed by LEX */}

%% /* end of rules section, begin subroutines section */

int yywrap(void)
{ return 1;}