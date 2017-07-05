#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "test.h"
#include <ctype.h>

void addVariable(LinkedList *list, char *name, double value) {
    int found = 0;
    Variable *current = list->first;
    Variable *var_to_replace;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            found = 1;
            var_to_replace = current;
            break;
        }
        current = current->next;
    }

    if (found) {
        var_to_replace->value = value;
    } else {
        Variable *new = malloc(sizeof(Variable));

        new->name = malloc(sizeof(name));
        strcpy(new->name, name);
        new->value = value;

        if (list->first == NULL) {
            list->first = new;
            list->last = new;
        } else {
            list->last->next = new;
            list->last = list->last->next;
        }
        // printf("%f\n", list->last->value);
        // printf("%s\n", list->last->name);
    }
}

double getValue(LinkedList *list, char* name) {
    Variable *var = list->first;
    while (var != NULL) {
        if (strcmp(name, var->name) == 0) {
            return var->value;
        }

        var = var->next;
    }

    return 0;
}

void runVariable(LinkedList *list){
	Variable *var = list->first->next;
	while(var != NULL) {
		printf("--------------\n");
		printf("|%s = %.2f|\n",var->name,var->value);
		printf("--------------\n");
		var = var->next;
	}
}

void checkVariable(LinkedList *list, char *name){
	if (list == NULL)
	{
		printf("Oups nous n'avons pas de variable enregistre\n");
	} else {
		Variable *var = list->first->next;
		int find = 0;
		while(var != NULL){
			if (strcmp(name,var->name) == 0)
			{
				find = 1;
				printf("on a trouve la variable \n");
				printf("%s -> %f\n",var->name,var->value);
				break;
			}
			var = var->next;
		}
		if (find == 0)
		{
			printf("Cette variable n'existe pas \n");
		}
	}
}
void to_lower(char *name){
	int i =0;
	 while( name[i] ) 
   {
      putchar(tolower(name[i]));
      i++;
   }
}
void to_upper(char *name){
    int j =0;
    while( name[j] )
    {
        putchar(toupper(name[j]));
        j++;
    }
}