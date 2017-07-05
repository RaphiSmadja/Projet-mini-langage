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
"while"	{  yylval.node = createNode(NTWHILE); return WHILE;}
"for"	{yylval.node = createNode(NTFOR); return(FOR); }
"show"  { yylval.node = createNode(NTSHOWVAR); return(SHOWVAR); }
"ToUpperCase"  { yylval.node = createNode(NTTOUPPER); return(TOUPPER); }
"ToLowerCase"	{ yylval.node = createNode(NTTOLOWER); return(TOLOWER); }


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

"--"   { yylval.node = createNode(NTDECREMENTATION); return(DECREMENTATION); }
"++"   { yylval.node = createNode(NTINCREMENTATION); return(INCREMENTATION); }
"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }
"="  { yylval.node = createNode(NTAFF); return(AFF); }
">"  { yylval.node = createNode(NTSUP); return(SUP); }
"<"  { yylval.node = createNode(NTINF); return(INF); }
"<="  { yylval.node = createNode(NTLE); return(LE); }
">+"  { yylval.node = createNode(NTGE); return(GE); }
"=="  { yylval.node = createNode(NTEQ); return(EQ); }
"!="  { yylval.node = createNode(NTNE); return(NE); }
"&&"  { yylval.node = createNode(NTAND); return(AND); }
"||"  { yylval.node = createNode(NTOR); return(OR); }




";"    { return(COLON); }

"\n"   { return(EOL); }
