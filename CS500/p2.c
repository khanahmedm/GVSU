/***************************************************************/
/* Author: Ahmed M Khan
/* Course No/Section: CS 500
/* Date: 05/29/2002
/* File Name: p2.c
/* Project No: 2
/* Description: C program 'Binary Search Tree Operations'
/****************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TRUE   1
#define FALSE  0

typedef int BOOLEAN;
typedef int ETYPE;
typedef int SIZE;

/*Tree node structure*/
typedef struct NODE *TREE;
struct NODE {
	ETYPE element;
	TREE  leftChild, rightChild;
	SIZE size;
};


/* insert function */
TREE insert(ETYPE x, TREE T)
{
	if (T == NULL) {
		T = (TREE) malloc(sizeof(struct NODE));
		T->element = x;
		T->size++;
		T->leftChild = NULL;
		T->rightChild = NULL;
	}
	else if (x < T->element)
	{
		T->leftChild = insert(x, T->leftChild);
		T->size++;
	}
	else if (x > T->element)
	{
		T->rightChild = insert(x, T->rightChild);
		T->size++;
	}
	return T;
}

/* lookup function */
BOOLEAN lookup(ETYPE x, TREE T)
{
	if (T == NULL)
		return FALSE;
	else if (x == T->element)
		return TRUE;
	else if (x < T->element)
		return lookup(x, T->leftChild);
	else /* x must be > T->element */
		return lookup(x, T->rightChild);
}

/* adding nodes */
TREE addNodes( TREE T)
{
	
	int i, elem;

	for(i=0;i<10;i++)
	{
		elem = rand()%500;
		if(!lookup(elem,T))
			T=insert(elem,T);
		else
		{
			i--;
			continue;
		}
	}
	return T;
}

/* print tree node values in inorder fashion*/
void print ( TREE T)
{
	if(T!=NULL)
	{
		print(T->leftChild);
		printf("%d\n",T->element);
		print(T->rightChild);
	}
}

/* get tree number of nodes */
int count ( TREE T)
{
	if(T==NULL)
		return 0;
	else	
	return T->size; 
}
		
/* main function*/
int main ()
{
	TREE t = NULL;
	int elem,i,size=0, option;
	srand ( time(NULL) );	
     		
	elem = rand() % 100;
	if (!lookup(elem, t))
	  t = insert (elem, t);


	printf("\nMain Menu\n\n\n");
	printf("(1) Add Nodes\n");
	printf("(2) Count nodes\n");
	printf("(3) Print tree\n");
	printf("(4) Quit\n");
	
		
	do{
		printf("Enter Choice:");
		scanf("%d",&option);
		
		if(option==1)		
			t=addNodes(t);
		if(option==2)
			printf("Size is : %d\n",count(t));
		else if(option==3)
			print(t);
		else if(option==4)	
			return 0;
  	} while(option>0 && option <4);
}

