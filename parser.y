%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token COMMA SEMICOLON COLON PARENTHESES1 PARENTHESES2 BRACKET1 BRACKET2 PLUS MINUS MULTIPLY DIVIDE MOD COLONEQUAL LESS LESSTHAN NEQUAL LARGERTHAN LARGER EQUAL AND OR NOT IDENT KWARRAY KWBEGIN KWBOOLEAN KWDEF KWDO KWELSE KWEND KWFALSE KWFOR KWINTEGER KWIF KWOF KWPRINT KWREAD KWREAL KWSTRING KWTHEN KWTO KWTRUE KWRETURN KWVAR KWWHILE OCTAL INT FLOAT SCIENTIFIC STRING

%start program

%left OR
%left AND
%left NOT
%left EQUAL 
%left LESS LESSTHAN LARGERTHAN LARGER NEQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%%

program             : programname SEMICOLON programbody KWEND IDENT {;}
programbody         : _declaration_vc _declaration_func compound_statement {;}

_declaration_vc     : epsilon {;}
                    | declaration_vc _declaration_vc {;}
declaration_vc      : declaration_var {;}
                    | declaration_con {;}

_declaration_func   : epsilon {;}
                    | declaration_func _declaration_func {;}
declaration_func    : identifier PARENTHESES1 _arguments PARENTHESES2 SEMICOLON compound_statement KWEND identifier {;}
                    | identifier PARENTHESES1 _arguments PARENTHESES2 COLON type SEMICOLON compound_statement KWEND identifier {;}

/* statements */
compound_statement  : KWBEGIN _declaration_vc_l _statement KWEND {;}

_declaration_vc_l   : epsilon {;}
                    | declaration_vc_l _declaration_vc_l {;}
declaration_vc_l    : declaration_var_l {;}
                    | declaration_con_l {;}

_statement          : epsilon {;}
                    | statement _statement {;}
statement           : compound_statement {;}
                    | simple_statement {;}
                    | cond_statement {;}
                    | while_statement {;}
                    | for_statement {;}
                    | return_statement {;}
                    | procedure_call {;}

simple_statement    : variable_reference COLONEQUAL expression SEMICOLON {;}
                    | KWPRINT expression SEMICOLON {;}
                    | KWREAD variable_reference SEMICOLON {;}

function_invocation : identifier PARENTHESES1 _expression PARENTHESES2 {;}
procedure_call      : identifier PARENTHESES1 _expression PARENTHESES2 SEMICOLON {;}

cond_statement      : KWIF expression KWTHEN _statement KWELSE _statement KWEND KWIF {;}
                    | KWIF expression KWTHEN _statement KWEND KWIF {;}

while_statement     : KWWHILE expression KWDO _statement KWEND KWDO {;}
for_statement       : KWFOR identifier COLONEQUAL integer_constant KWTO integer_constant KWDO _statement KWEND KWDO {;}
return_statement    : KWRETURN expression SEMICOLON {;}

/* variable and expressions */
variable_reference  : identifier {;}
                    | array_reference {;}
array_reference     : identifier BRACKET1 integer_expression BRACKET2 _integer_expression {;}

_integer_expression : epsilon {;}
                    | BRACKET1 integer_expression BRACKET2 _integer_expression {;}
integer_expression  : expression {;}

_expression         : epsilon {;}
                    | expression __expression {;}
__expression        : epsilon {;}
                    | COMMA expression __expression {;}

expression          : PARENTHESES1 expression PARENTHESES2 {;}
                    | MINUS expression %prec MULTIPLY {;} /* unary, left associativity */
                    | expression MULTIPLY expression {;}
                    | expression DIVIDE expression {;}
                    | expression MOD expression {;}
                    | expression PLUS expression {;}
                    | expression MINUS expression {;}
                    | expression LESS expression {;}
                    | expression LESSTHAN expression {;}
                    | expression EQUAL expression {;}
                    | expression LARGERTHAN expression {;}
                    | expression LARGER expression {;}
                    | expression NEQUAL expression {;}
                    | NOT expression {;}
                    | expression AND expression {;}
                    | expression OR expression {;}
                    | literal_constant {;}
                    | function_invocation {;}
                    | variable_reference {;}

/* data types and declarations */
__arguments         : epsilon {;}
                    | SEMICOLON arguments __arguments {;}
_arguments          : epsilon {;}
                    | arguments __arguments {;}
arguments           : identifier_list COLON type {;}

_identifier_list    : epsilon {;}
                    | COMMA identifier _identifier_list {;}
identifier_list     : identifier _identifier_list {;}

declaration_var     : KWVAR identifier_list COLON scalar_type SEMICOLON {;}
                    | KWVAR identifier_list COLON KWARRAY integer_constant KWTO integer_constant KWOF type SEMICOLON {;}
declaration_con     : KWVAR identifier_list COLON literal_constant SEMICOLON {;}

declaration_var_l   : KWVAR identifier_list COLON scalar_type SEMICOLON {;}
                    | KWVAR identifier_list COLON KWARRAY integer_constant KWTO integer_constant KWOF type SEMICOLON {;}
declaration_con_l   : KWVAR identifier_list COLON literal_constant SEMICOLON {;}

integer_constant    : INT { /*int >= 0*/;}
                    | OCTAL {;}
literal_constant    : INT {;}
                    | OCTAL {;}
                    | FLOAT {;}
                    | SCIENTIFIC {;}
                    | STRING {;}
                    | KWTRUE {;}
                    | KWFALSE {;}

scalar_type         : KWINTEGER {;}
                    | KWREAL {;}
                    | KWBOOLEAN {;}
                    | KWSTRING {;}

type                : scalar_type {;}
                    | KWARRAY integer_constant KWTO integer_constant KWOF type {;}

programname	        : identifier {;}
identifier          : IDENT ;
epsilon:            ;

%%

int yyerror( char *msg )
{
    fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
    fprintf( stderr, "|--------------------------------------------------------------------------\n" );
    exit(-1);
}

int  main( int argc, char **argv )
{
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );
	
	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}
	
	yyin = fp;
	yyparse();

	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	exit(0);
}

