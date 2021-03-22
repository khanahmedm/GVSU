/***************************************************************/
/* Author: Ahmed M Khan
/* Course No/Section: CS 500
/* Date: 06/05/2002
/* File Name: p3.c
/* Project No: 3
/* Description: C program 'List implementation'
/****************************************************************/
#include<stdlib.h>
#include<stdio.h>

#define MAX 50
#define TRUE 1
#define FALSE 0

typedef int BOOLEAN; 
typedef struct {
	int A[MAX];
	int length;
} LIST;

/*Prototypes*/
void insert (int x, LIST *pL);
void delete (int x, LIST *pL);
void print (LIST *pL);
int retrieve(int x, LIST *pL);
int empty(LIST *pL);
int full(LIST *pL);
int length(LIST *pL);

/*main function*/ 
int main()
{
	/* variable and pointer declarations*/
	FILE *fptr;
	int ch, value, pos=0, found, index;
	char opt, numString[3];
	LIST list;
	LIST *listptr;
	listptr=&list;
	listptr->length=0;
	
	/*open file for reading*/
	fptr=fopen("pj3.dat","r");

	/*manipulating file*/
	while((ch=getc(fptr))!=EOF)
	{
		if(ch!='\n')
		{
			if( ch>=65 && ch<=90)
				opt=ch;
			else
				numString[pos++]=ch;
		}
		else if(ch=='\n')
		{
			pos=0;
			value=atoi(numString);
			bzero(numString, 3);
			if(opt=='I')
				insert(value,listptr);
			else if(opt=='D')
			{	
				found=lookup(value, listptr);
				if (found==1)
					delete(value, listptr);
				else
			printf("\nValue not found, can not be deleted\n");
			
			}
			else if(opt=='P')
				print(listptr);
			else if(opt=='R')
			{
				index=value;
				value=retrieve(index, listptr);
				printf("Value at %d is %d\n",
					index, value);
			}
			else if(opt=='E')
			{
				if(empty(listptr))
					printf("List is not empty.\n");
				else
					printf("List is empty.\n");
			}
			else if(opt=='F')
			{
				if(full(listptr))
					printf("List is full.\n");
				else
					printf("List is not full.\n");
			}
			else if(opt=='L')
				printf("List length=%d\n",length(listptr));
			value=0;
		
		}
	}
	/*close file*/
	fclose(fptr);

	return 0;	

}

/*lookup function*/
BOOLEAN lookup (int x, LIST *pL) 
{
	int i = 0;
	
	while (i < pL->length && x > pL->A[i])
		i++;

	return (i < pL->length && pL->A[i] == x);

}

/*insert value in the list*/
void insert (int x, LIST *pL)
{
	int i=0, j;
	while (i < pL->length && x > pL->A[i])
		i++;

	for(j=pL->length-1; j>=i; j--)
		pL->A[j+1]=pL->A[j];

	pL->A[i]=x;
	(pL->length)++;

	printf("Inserting Value %d\n",pL->A[i]);


}

/*print list values*/
void print( LIST *pL)
{
	int i=0;
	
	printf("\nPrinting List\n");
	while(i<pL->length)
		printf("%d\n",pL->A[i++]);
}

/*delete value from the list*/
void delete( int x, LIST *pL)
{
	int i=0,j;
	
	while(i<pL->length && x > pL->A[i])
	 i++;

	if(x==pL->A[i])
	{
		printf("Deleteing value %d\n",x);
		
		for(j=i;j<=pL->length-2;j++)
			pL->A[j]=pL->A[j+1];
	}
	(pL->length)--;

}	

/*retrieve value from index*/
int retrieve( int i, LIST * pL)
{
	return pL->A[i];
}

/* Is empty function*/
int empty(LIST *pL)
{
	if(pL->length==0)
		return 0;
	else
		return 1;
}	

/* Is full function */
int full(LIST *pL)
{
	if (pL->length==MAX)
		return 1;
	else
		return 0;
}

/* return list length*/
int length(LIST *pL)
{
	return pL->length;
}
