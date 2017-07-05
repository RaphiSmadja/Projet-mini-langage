#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <setjmp.h>
#include "minipseudtree.h"
#include "test.h"

int printDepth = 0;
int funcDepth = 0;

LinkedList *values;

double evalExpr(Node *node) {
    double res;
    double result=0.0;
    switch ( node->type ) {
	    case NTEMPTY:  return 0.0;
        case NTINCREMENTATION:
            res=getValue(values, node->children[0]->var);
            result = res+1;
            addVariable(values,node->children[0]->var,result);
            runVariable(values);
            return result;
        case NTDECREMENTATION:
            res=getValue(values, node->children[0]->var);
            result = res-1;
            addVariable(values,node->children[0]->var,result);
            runVariable(values);
            return result;
        case NTAFF:
           if (values == NULL) {
                values = malloc(sizeof(LinkedList));
            } 
            printf("%s\n",node2String(node->children[0]));
            addVariable(values, node->children[0]->var, evalExpr(node->children[1]));
            runVariable(values);
            return node->children[1]->val;
        case NTNUM: return node->val;
	    case NTPLUS: return evalExpr(node->children[0])	+ evalExpr(node->children[1]);
	    case NTMIN: return evalExpr(node->children[0]) - evalExpr(node->children[1]);
	    case NTMULT: return evalExpr(node->children[0])	* evalExpr(node->children[1]);
	    case NTDIV: return evalExpr(node->children[0]) / evalExpr(node->children[1]);
	    case NTPOW: return pow(evalExpr(node->children[0]),	evalExpr(node->children[1]));
        case NTVAR: return getValue(values, node->var);
		case NTSUP:  return evalExpr(node->children[0]) > evalExpr(node->children[1]);
        case NTINF:  return evalExpr(node->children[0]) < evalExpr(node->children[1]);
        case NTLE:  return evalExpr(node->children[0]) <= evalExpr(node->children[1]);
        case NTGE:  return evalExpr(node->children[0]) >= evalExpr(node->children[1]);
        case NTEQ:  return evalExpr(node->children[0]) == evalExpr(node->children[1]);
        case NTNE:  return evalExpr(node->children[0]) != evalExpr(node->children[1]);
        case NTAND:  return evalExpr(node->children[0]) && evalExpr(node->children[1]);
        case NTOR:  return evalExpr(node->children[0]) || evalExpr(node->children[1]);
        case NTTHENELSE:  return getValue(values, node->var);
        case NTTHEN:  return getValue(values, node->var);
        case NTINTR:  return getValue(values, node->var);/*
        case NTSHOWVAR:  return getValue(values, node->var);*/
	    default: 
		    printf("Error in evalExpr ... Wrong node type: %s\n", node2String(node));
		    exit(1);
    };
}



void evalInst(Node* node) {
	double val;
	switch (node->type) {
        case NTAFF:  
            if (values == NULL) {
                values = malloc(sizeof(LinkedList));
            } 
            printf("%s\n",node2String(node->children[0]));
            addVariable(values, node->children[0]->var, evalExpr(node->children[1]));
            runVariable(values);
        break;
        case NTSHOWVAR:   
     		checkVariable(values,node->children[0]->var);
        break;
        case NTTOUPPER:
            to_upper(node->children[0]->var);
            break;
        case NTTOLOWER:   
     		to_lower(node->children[0]->var);
        break;
        case NTINSTLIST:
        	evalInst(node->children[0]);
        	evalInst(node->children[1]);
        break; 
        	return;
        case NTNUM:
        	printf("%f\n", evalExpr(node));
        break;
        case NTPLUS:
        	printf("%f\n", evalExpr(node));
        break;
        case NTMIN:
        	printf("%f\n", evalExpr(node));
        break;
        case NTMULT:
        	printf("%f\n", evalExpr(node));
        break;
        case NTDIV:
        	printf("%f\n", evalExpr(node));
        break;
        case NTPOW:
        	printf("%f\n", evalExpr(node));
        break;
		case NTSUP:
            if(evalExpr(node->children[0]) < evalExpr(node->children[1])){
                printf("okay");
            }
            else{
                printf("le deuxieme");
            }
			break;

        case NTINF:
            printf("%f\n", evalExpr(node));
            break;
        case NTLE:
            break;
        case NTGE:
            break;
        case NTEQ:
            break;
        case NTNE:
            break;
        case NTAND:
            break;
        case NTOR:
            break;
        case NTINCREMENTATION:
            printf("%f\n", evalExpr(node));
            break;
        case NTDECREMENTATION:
            printf("%f\n", evalExpr(node));
            break;
        case NTIF:
            if(evalExpr(node->children[0])==1){
                printf("%f\n", evalExpr(node->children[1]->children[0]));
            }else{
                printf("%f\n", evalExpr(node->children[1]->children[1]));
            }
            break;

        case NTTERN:
            if(evalExpr(node->children[0])==1){
                printf("%f\n", evalExpr(node->children[1]->children[0]));
            }else{
                printf("%f\n", evalExpr(node->children[1]->children[1]));
            }
            break;


        case NTWHILE:

            while(evalExpr(node->children[0])==1){
                printf("%f\n", evalExpr(node->children[1]->children[0]));
            }
            break;
        case NTFOR:
            while(evalExpr(node->children[0]->children[0])==1){
                printf("%f\n", evalExpr(node->children[1]->children[0]));
                evalInst(node->children[0]->children[1]);
            }
            break;
        case NTTHENELSE:
            break;

        case NTTHEN:
            break;
        case NTINTR:
            break;

	    case NTEMPTY:            
            break;
        default:
        	printf("Error in evalInst ... Wrong node type: %s\n", node2String(node));
        	exit (1);
        };
    }

void eval(Node *node) {
	evalInst(node);
}