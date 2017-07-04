%option noyywrap
%{

#include "minipseud.h"
#include <stdlib.h>
#include "minipseudtree.h"

%}

empty    [ \t]+

num   [0-9]

int    {num}+

exp  [eE][+-]?{int}
var   [_a-zA-Z]+[_a-zA-Z0-9]*
real      {int}("."{int})?{exp}?



%%

"if"  { yylval.node = createNode(NTIF); return(IF); }
"else"  { yylval.node = createNode(NTTHENELSE); return(ELSE); }
"then"	{  yylval.node = createNode(NTTHEN); return THEN;}
"show"  { yylval.node = createNode(NTSHOWVAR); return(SHOWVAR); }
"ToLowerCase"	{ yylval.node = createNode(NTTOLOWER); return(TOLOWER); }
"for"	{return FOR;}

{empty}  { /* Nothing */ }

"("   return(OP_PAR);
")"   return(CL_PAR);

{var}    {
    yylval.node = createNode(NTVAR);
    yylval.node->var = (char*)_strdup(yytext);
    return(VAR);
    }

{real}    {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUM);
    }


"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }
"="  { yylval.node = createNode(NTAFF); return(AFF); }
">"  { yylval.node = createNode(NTSUP); return(SUP); }




";"    { return(COLON); }

"\n"   { return(EOL); }
