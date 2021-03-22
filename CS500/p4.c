/***************************************************************/
/* Author: Ahmed M Khan
/* Course No/Section: CS 500
/* Date: 06/12/2002
/* File Name: p4.c
/* Project No: 4
/* Description: C program 'Event-Driven Simulation'
/****************************************************************/
#include <iostream.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include "queue.h"

double expdist(double mean);

double expdist (double mean) 
{
	double r = rand();
	r /= RAND_MAX;
	return -mean*log(r);
}

int main () 
{
	int i, id=1, did=0;
	double t=0; /* starting time */
	double clock, next, avail=0, dclock=0;
	QUEUE pQueue;

	next=expdist(1);
	clock=next;

	srand(time(0));
	
	InitQueue(&pQueue);

	while(clock < 480 || IsEmpty(&pQueue)==FALSE)
	{
		if(clock <480)
		{
			if (clock==next)
				Enqueue(id, clock, &pQueue);
		id++;
		next=clock+expdist(1);
		}
	
		if(clock>=avail)
			if(IsEmpty(&pQueue)==FALSE)
			{
				dclock=clock;
				Dequeue(&did, &dclock, &pQueue);
			}
		ShowQueue(&pQueue);
		
		
		avail=clock+expdist(5);
		if(next<480)
		{
			if(next<avail)
				clock=next;
			else
				clock=avail;
		}
		else
			clock=avail;
		
	}								
		

	return 0;

}


