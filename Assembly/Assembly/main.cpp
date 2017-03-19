#include <iostream>
#include <conio.h>

#include "MatLib.h"

#define DATA_SIZE 48
struct data_struct
{
	data_struct() : life(10), attack(10), speed(10) {}
	~data_struct() {}

	int life = 10;
	int attack = 5;
	int speed = 5;
};

int main()
{
	data_struct data [4];
	int buffer[6];
	for (int k = 0; k < 4; k++)
	{
		buffer[k] = rand() % 8;
	}

	clean_buffer(buffer, 6 * 4);
	printf("gg");

	int a = 5;
	int b = 2;
	int t = rem(a,b);
	t = divide(t, b);

	int result = 4 + 5;
	
	_getch(); // This stop the program waiting for input


	
	return 0;
}