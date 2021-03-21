/***************************************************************/

/* Author: Ahmed M Khan

/* Course No/Section: CS 500

/* Date: 05/20/2002

/* File Name: p1.c

/* Project No: 1

/* Description: C program 'List of Books'

/****************************************************************/

#include <stdio.h>
#define MAX 100

 struct Book {

	int code;

	float price;

	};

/* Prototypes */

void loadArray (struct Book list[], int* numOfBooksPtr);
void printArray (struct Book list[], int numOfBooks); 
int Count (struct Book list[], int numOfBooks, float targetPrice);
void Sort (struct Book list[], int numOfBooks);
float findPrice (struct Book list[], int numOfBooks, int targetCode);

/* main function */
main()

{
	/* declaring required variables*/
	int numOfBooks, count, targetCode;
	float targetPrice, priceFound;
	struct Book list[MAX];
	
	/* loading list */
	loadArray (list, &numOfBooks);

	/*printing list */
	printArray (list, numOfBooks);

	/**********************************
	  getting & printing number of Books
	  having price less than target
	***********************************/
	printf("\nPlease enter target price:");
	scanf("%f", &targetPrice);
	count= Count( list, numOfBooks, targetPrice);
	printf("\nNumber of Books having price less than target: %d\n", 
			count);

	/*Sorting & printing sorted list*/	
	Sort( list, numOfBooks);
	printArray (list, numOfBooks);

	/********************************* 
	   getting and printing the price
	   of the target book
	**********************************/
	printf("\nPlease enter target code:");
	scanf("%d", &targetCode);
	priceFound=findPrice(list, numOfBooks, targetCode);
	if( priceFound >0 )
		printf("\nPrice is: %7.2f\n", priceFound);
	else
		printf("\nBook not found\n");
		
	return 0;

}

 

void loadArray (struct Book list[], int* numOfBooksPtr)

/* loads array list with input data from keyboard */

{

	int aCode;
	float aPrice;

	*numOfBooksPtr = 0;

	printf ("Code of Book ? ");
	scanf("%d", &aCode);

	while ( aCode != 9999 )

	{

		printf ("Price of Book ? ");
		scanf("%f", &aPrice);

		list[*numOfBooksPtr].code = aCode;
		list[*numOfBooksPtr].price = aPrice;

		(*numOfBooksPtr)++;
		printf ("Code of Book ? ");
		scanf("%d", &aCode);

	}

}

 

void printArray (struct Book list[], int numOfBooks)

 /* display contents of array list on screen */

{

	int index;

	printf("\n\n%10s%10s", "CODE", "PRICE");
	printf("\n");

	for (index = 0; index < numOfBooks; index++)
	{
		printf("%10d%10.2f\n", list[index].code, list[index].price);

	}

}

int Count(struct Book list[], int numOfBooks, float targetPrice)
/* counting number of books price less than target*/
{
	int index, count=0;

	for(index=0; index<numOfBooks; index++)
	{
		if(list[index].price< targetPrice)
			count++;
	}
	return count;

}

void Sort( struct Book list[], int numOfBooks)
/* sorting the Book list*/
{
	int out, in;
	struct Book temp;

	for(out=0; out < numOfBooks; out++)
		for(in=out+1; in < numOfBooks; in++)
			if(list[out].code > list[in].code)
			{
				temp.code=list[in].code;
				temp.price=list[in].price;

				list[in].code=list[out].code;
				list[in].price=list[out].price;

				list[out].code=temp.code;
				list[out].price=temp.price;
			}
}

float findPrice( struct Book list[], int numOfBooks, int targetCode)
/*finding the price of the book specified by target code*/
{
	int index, found=0;
	
	for(index=0; index < numOfBooks; index++)
		if(list[index].code==targetCode)
		{
			return list[index].price;
		}

	return 0;
}
