#ifndef MINIPSEUDTREE
# define MINIPSEUDTREE
    
enum NodeType {
	NTEMPTY = 0,
	NTINSTLIST = 1,
	NTNUM   = 201,
	NTVAR = 222,
	NTPLUS  = 321,
	NTMIN   = 322,
	NTMULT  = 323,
	NTDIV   = 324,
	NTPOW   = 325,
	NTEQ = 326,
	NTAFF = 327,
	NTSHOWVAR = 328,
	NTSUP = 329,
    NTIF= 330,
    NTTHENELSE= 331,
    NTTHEN= 332,
    NTTOLOWER= 333,
    NTTOUPPER= 334,
    NTINF= 335,
    NTLE= 336,
    NTGE= 337,
    NTNE= 338,
    NTAND= 339,
    NTOR= 340,
    NTINCREMENTATION  = 341,
    NTDECREMENTATION  = 342

    /*NTSCANF=333 */

};
   
typedef struct Node {
	enum NodeType type;
	union {
        float val;
        char* var;
		struct Node** children;
	} ;
} Node;

Node* createNode(int type);

Node* nodeChildren(Node* father, Node *child1, Node *child2);

const char* node2String(Node *node);

void printGraph(Node *root);

#endif
