%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "minipseudtree.h"
#include "minipseudeval.h"

extern int  yyparse();
extern FILE *yyin;


Node root;
 

%}

%union {
	struct Node *node;
}


%token   <node> NUM VAR
%token   <node> PLUS MIN MULT DIV POW AFF
%token   OP_PAR CL_PAR COLON
%token   EOL


%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
%type   <node> VarExpr
%type   <node> MixedExpr
  

%left OR
%left AND
%left EQ NEQ
%left GT LT GET LET
%left PLUS  MIN
%left MULT  DIV
%left NEG NOT
%right  POW

%start Input
%%

Input:
      {/* Nothing ... */ }
  | Line Input { /* Nothing ... */ }


Line:
    EOL {  }
  | Instlist EOL { exec($1);    }
  ; 

Instlist:
    Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, createNode(NTEMPTY)); } 
  | Instlist Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, $2); }
  ;

Inst:
  Expr COLON { $$ = $1; }  
	|VAR AFF MixedExpr COLON{  $$ = nodeChildren($2, $1, $3); }
  ;


Expr:
  NUM     { $$ = $1; }
  | Expr PLUS Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr MIN Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr MULT Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr DIV Expr      { $$ = nodeChildren($2, $1, $3); }
  | MIN Expr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | Expr POW Expr      { $$ = nodeChildren($2, $1, $3); }
  | OP_PAR Expr CL_PAR { $$ = $2; }
  ;

VarExpr:
  VAR     { $$ = $1; }
  | VarExpr PLUS VarExpr     { $$ = nodeChildren($2, $1, $3); }
  | VarExpr MIN VarExpr      { $$ = nodeChildren($2, $1, $3); }
  | VarExpr MULT VarExpr     { $$ = nodeChildren($2, $1, $3); }
  | VarExpr DIV VarExpr      { $$ = nodeChildren($2, $1, $3); }
  | MIN VarExpr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | VarExpr POW VarExpr      { $$ = nodeChildren($2, $1, $3); }
  | OP_PAR VarExpr CL_PAR { $$ = $2; }
  ;

MixedExpr:
  VarExpr { $$ = $1; }
  | Expr { $$ = $1; }
  | VarExpr PLUS Expr { $$ = nodeChildren($2, $1, $3); }
  | VarExpr MIN  Expr { $$ = nodeChildren($2, $1, $3); }
  | VarExpr MULT Expr { $$ = nodeChildren($2, $1, $3); }
  | VarExpr DIV  Expr { $$ = nodeChildren($2, $1, $3); }

  | Expr PLUS VarExpr { $$ = nodeChildren($2, $1, $3); }
  | Expr MIN  VarExpr { $$ = nodeChildren($2, $1, $3); }
  | Expr MULT VarExpr { $$ = nodeChildren($2, $1, $3); }
  | Expr DIV  VarExpr { $$ = nodeChildren($2, $1, $3); }

  | MixedExpr PLUS MixedExpr { $$ = nodeChildren($2, $1, $3); }
  | MixedExpr MIN  MixedExpr { $$ = nodeChildren($2, $1, $3); }
  | MixedExpr MULT MixedExpr { $$ = nodeChildren($2, $1, $3); }
  | MixedExpr DIV  MixedExpr { $$ = nodeChildren($2, $1, $3); }
  ;
%%

 
 

int exec(Node *node) {
  printGraph(node);
  eval(node);
}

 

int yyerror(char *s) {
  printf("%s\n", s);
}

 

int main(int arc, char **argv) {
   if ((arc == 3) && (strcmp(argv[1], "-f") == 0)) {
    
    FILE *fp=fopen(argv[2],"r");
    if(!fp) {
      printf("Impossible d'ouvrir le fichier à executer.\n");
      exit(0);
    }      
    yyin=fp;
    yyparse();
		  
    fclose(fp);
  }  
  exit(0);
}
