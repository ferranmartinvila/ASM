#include <iostream>
#include <conio.h>

using namespace std;

#include "MatLib.h"

int main()
{

	float g = 4.5;
	float k = 2.5;
	//float t = sum(k, g);
	int buffer[4];
	for (int k = 0; k < 4; k++)
	{
		buffer[k] = rand() % 4;
	}

	int result = sum_array_values(buffer,4);
	
	_getch(); // This stop the program waiting for input


	
	return 0;
}