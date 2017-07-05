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


%token   <node> NUM VAR SHOWVAR TOLOWER TOUPPER /*SCANF*/
%token   <node> IF THEN ELSE FOR WHILE PLUS MIN MULT SUP DIV POW AFF  LT LR EQ GT GE INF LE NE  AND OR INCREMENTATION DECREMENTATION /*SHOWVAR*/
%token   OP_PAR CL_PAR COLON
%token   EOL


%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
//%type   <node> Expr2
%type   <node> Statement
  

%left OR
%left AND
%left EQ NEQ
%left GT LT GET LET
%left PLUS  MIN SUP NE LE INF GE
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
  | VAR AFF Expr COLON{  $$ = nodeChildren($2, $1, $3); }
  | SHOWVAR OP_PAR VAR CL_PAR COLON{ $$ = nodeChildren($1,$3,createNode(NTEMPTY));}
  | TOLOWER OP_PAR VAR CL_PAR COLON{ $$ = nodeChildren($1,$3,createNode(NTEMPTY));}
  | TOUPPER OP_PAR VAR CL_PAR COLON{ $$ = nodeChildren($1,$3,createNode(NTEMPTY));}
  /*| SCANF OP_PAR CL_PAR COLON{ $$ = nodeChildren($2,$1,createNode(NTEMPTY));}*/
  | IF OP_PAR Expr CL_PAR Statement  { $$ = nodeChildren($1, $3, $5);}
  | WHILE OP_PAR Expr CL_PAR Statement {  $$ = nodeChildren($1, $3, $5);}
  | FOR OP_PAR Statement CL_PAR Statement {  $$ = nodeChildren($1, $3, $5);}
  ;


Statement:
    THEN Expr COLON Expr {$$ = nodeChildren($1, $2, $4);}
   | THEN Expr COLON {$$ = nodeChildren($1, $2,  createNode(NTEMPTY));}
   | THEN Expr ELSE Expr COLON {$$ = nodeChildren($3, $2, $4);}


Expr:
  NUM     { $$ = $1; }
  | VAR     { $$ = $1; }
  | Expr AND Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr OR Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr SUP Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr INF Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr LE Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr NE Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr GE Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr EQ Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr PLUS Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr MIN Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr MULT Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr DIV Expr      { $$ = nodeChildren($2, $1, $3); }
  | MIN Expr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | Expr POW Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr INCREMENTATION     { $$ = nodeChildren($2, $1, createNode(NTEMPTY)); }
  | Expr DECREMENTATION     { $$ = nodeChildren($2, $1, createNode(NTEMPTY)); }
  ;
%%



 char st[100][10];
 int top=0;
 char i_[2]="0";
 char temp[2]="t";

 int label[20];
 int lnum=0;
 int ltop=0;

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
