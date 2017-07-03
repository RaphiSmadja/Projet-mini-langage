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
	switch ( node->type ) {
	    case NTEMPTY:  return 0.0;
	    case NTNUM: return node->val;	 
	    case NTPLUS: return evalExpr(node->children[0])	+ evalExpr(node->children[1]);
	    case NTMIN: return evalExpr(node->children[0]) - evalExpr(node->children[1]);
	    case NTMULT: return evalExpr(node->children[0])	* evalExpr(node->children[1]);
	    case NTDIV: return evalExpr(node->children[0]) / evalExpr(node->children[1]);
	    case NTPOW: return pow(evalExpr(node->children[0]),	evalExpr(node->children[1]));
        case NTVAR: return getValue(values, node->var);
		case NTSUP:  return evalExpr(node->children[0]) > evalExpr(node->children[1]);
        case NTTHENELSE:  return getValue(values, node->var);
        case NTTHEN:  return getValue(values, node->var);
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
            addVariable(values, node->children[0]->var, evalExpr(node->children[1]));
            runVariable(values);
            break;
        case NTINSTLIST:
        	evalInst(node->children[0]);
        	evalInst(node->children[1]);
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
        case NTIF:
            if(evalExpr(node->children[0])==1){
                printf("%f\n", evalExpr(node->children[1]->children[0]));
            }else{
                printf("%f\n", evalExpr(node->children[1]->children[1]));
            }
            break;
        case NTTHENELSE:
            break;

        case NTTHEN:
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