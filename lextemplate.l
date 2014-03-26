%{
#define LIST               strcat(buf, yytext)
#define token(t)                { LIST; if (Opt_T) printf("<%s>\n", #t); }
#define tokenInteger(t, i)      { LIST; if (Opt_T) printf("<%s:%d>\n", #t, i); }
#define tokenFloat(t, f)        { LIST; if (Opt_T) printf("<%s:%f>\n", #t, f); }
#define tokenScientific(t, f)   { LIST; if (Opt_T) printf("<%s:%f>\n", #t, f); }
#define tokenString(t, s)       { LIST; if (Opt_T) printf("<%s:%s>\n", #t, s); }
#define tokenId(t, id)          { LIST; if (Opt_T) printf("<%s:%s>\n", #t, id); }

#define MAX_LINE_LENG      256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char *removeDoubleQuote(char *in);
char *out;
%}

D   [0-9]
L   [a-zA-Z]
H   [a-fA-F0-9]
O   [0-7]

%Start IN_COMMENT

%%
<INITIAL>{
    [ \t]+  {
              LIST;
            }

    ","         { token(','); }
    ";"         { token(;); }
    ":"         { token(:); }
    "("         { token('('); }
    ")"         { token(')'); }
    "["         { token([); }
    "]"         { token(]); }

    "+"         { token(+); }
    "-"         { token(-); }
    "*"         { token(*); }
    "/"         { token(/); }
    "mod"       { token(mod); }
    ":="        { token(:=); }
    "<"         { token(<); }
    "<="        { token(<=); }
    "<>"        { token(<>); }
    ">="        { token(>=); }
    ">"         { token(>); }
    "="         { token(=); }
    "and"       { token(and); }
    "or"        { token(or); }
    "not"       { token(not); }

    "begin"     { token(KWbegin); }
    "array"     { token(KWarray); }
    "boolean"   { token(KWboolean); }
    "def"       { token(KWdef); }
    "do"        { token(KWdo); }
    "else"      { token(KWelse); }
    "end"       { token(KWend); }
    "false"     { token(KWfalse); }
    "for"       { token(KWfor); }
    "integer"   { token(KWinteger); }
    "if"        { token(KWif); }
    "of"        { token(KWof); }
    "print"     { token(KWprint); }
    "read"      { token(KWread); }
    "real"      { token(KWreal); }
    "string"    { token(KWstring); }
    "then"      { token(KWthen); }
    "to"        { token(KWto); }
    "true"      { token(KWtrue); }
    "return"    { token(KWreturn); }
    "var"       { token(KWvar); }
    "while"     { token(KWwhile); }

    \"([^\"]|(\"\"))*\"   { tokenString(string, removeDoubleQuote(yytext)); }
    {L}({L}|{D})*   { tokenId(id, yytext); }
    0|[1-9]{D}*     { tokenInteger(integer, atoi(yytext)); }
    0{O}+      { tokenString(octal, yytext); }
    (0?|[1-9]{D}*)(\.{D}*)    { tokenString(float, yytext); }
    (0?|[1-9]{D}*)(\.{D}*)?[eE][-+]?({D}*)  { tokenString(scientific, yytext); }

    \/\/([^&][^S^T][^+^-]).*$ {
        //printf("comment found 2: %s\n", yytext);
        LIST;
    }

    \/\/"&S+".*$ {
        //printf("S+ get\n");
        LIST;
        Opt_S = 1;
    }

    \/\/"&S-".*$ {
        //printf("S- get\n");
        LIST;
        Opt_S = 0;
    }

    \/\/"&T+".*$ {
        //printf("T+ get\n");
        LIST;
        Opt_T = 1;
    }

    \/\/"&T-".*$ {
        //printf("T- get\n");
        LIST;
        Opt_T = 0;
    }

    "/*"    {
              LIST;
              BEGIN IN_COMMENT;
            }
    \n      {
              LIST;
              if (Opt_S)
                printf("%d: %s", linenum, buf);
              linenum++; buf[0] = '\0';
            }
    \r\n    {
              LIST;
              if (Opt_S)
                printf("%d: %s", linenum, buf);
              linenum++; buf[0] = '\0';
            }
    . {
        printf("error at line %d: bad character \"%s\"\n", linenum, yytext);
        exit(1);
    }
}
<IN_COMMENT>{
    "*/"    { 
              LIST;
              BEGIN INITIAL;
            }
    .       {
              LIST;
            }
    \n      {
              LIST;
              if (Opt_S)
                printf("%d: %s", linenum, buf);
              linenum++; buf[0] = '\0';
            }
    \n\r    {
              LIST;
              if (Opt_S)
                printf("%d: %s", linenum, buf);
              linenum++; buf[0] = '\0';
            }
}

%%

char *removeDoubleQuote(char *in) {
    char *out = (char *)malloc((strlen(in)+1) * sizeof(char));
    int i_i, o_i=0;
    for( i_i=1 ; i_i<strlen(in)-1 ; i_i++ ) {
        if( in[i_i] != '\"' || in[i_i-1] != '\"' ){
            out[o_i] = in[i_i];
            o_i++;
        }
    }
    out[o_i] = '\0';
    //printf("out >> %s\n", out);
    return out;
}

int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }

  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }

  yyin = fp;

  yylex();

  exit(0);
}
