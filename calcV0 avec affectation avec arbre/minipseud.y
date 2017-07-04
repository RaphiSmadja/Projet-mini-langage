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
%token   <node> IF PLUS MIN MULT SUP DIV POW AFF  LT LR GT GE THEN ELSE FOR  INCREMENTATION DECREMENTATION/*SHOWVAR*/
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
%left PLUS  MIN SUP
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
  | FOR OP_PAR Expr COLON  Expr COLON Expr CL_PAR THEN Expr COLON { $$=$10; printf("-- BOUCLE FOR \n");}
  ;
  //| WHILE OP_PAR Expr CL_PAR THEN Expr COLON { $$ = $5; printf("-- WHILE  \n")} 

  //| IF OP_PAR Expr CL_PAR THEN Expr COLON{  $$=$6; test($3,$6);}
  // | IF OP_PAR Expr CL_PAR THEN Expr COLON{  $$=$6; test($3,$6); printf("IF FONCTIONNNE %d\n", $6->children[0]->var);}
  //THEN Expr COLON { if($3>2)then $$=$6; printf("IF FONCTIONNNE  \n");}
  //| Expr OP_PAR CL_PAR COLON  { $1();}
  // |IF OP_PAR Expr2 CL_PAR THEN Expr COLON{  $$ = nodeChildren($2, $1, $3); }
  // |SHOWVAR OP_PAR CL_PAR COLON{  $$ = nodeChildren(createNode(NTSHOWVAR), $1, createNode(NTEMPTY)); }
  // | IF OP_PAR Expr CL_PAR{lab1();}THEN Expr COLON{lab2();}


Statement:
   THEN Expr COLON {$$ = nodeChildren($1, $2,  createNode(NTEMPTY));printf("--BOUCLE IF THEN \n")}
   | THEN Expr ELSE Expr COLON {$$ = nodeChildren($3, $2, $4);printf("--BOUCLE IF THEN ELSE \n")}

//Expr2:
  // Expr GT Expr     { $$ = nodeChildren($2, $1, $3); }
  //;

Expr:
  NUM     { $$ = $1; }
  | VAR     { $$ = $1; }
  | Expr SUP Expr     { $$ = nodeChildren($2, $1, $3); }
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

 lab1()
 {
  lnum++;
  strcpy(temp,"t");
  strcat(temp,i_);
  printf("%s = not %s\n",temp,st[top]);
  printf("if %s goto L%d\n",temp,lnum);
  i_[0]++;
  label[++ltop]=lnum;
 }

test(Node *a, Node *b){

   printf("test %d \n",a->children[0]->var);
   printf("test2 %d \n",b->children[0]->var);
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
