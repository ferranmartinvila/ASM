#ifndef _MAT_LIB_
#define _MAT_LIB_

// Predefinition of all library methods (Link functions with the assembly code)

/* SUM c = a + b */		extern "C" int sum(int a, int b);
/* REST c = a - b */	extern "C" int rest(int a, int b);
/* MULT c = a * b */	extern "C" int mult(int a, int b);
/* DIV c = a / b */		extern "C" int divide(int a, int b);
/* REM c = a % b */		extern "C" int rem(int a, int b);

//extern "C" bool clean_buffer(void* buffer, unsigned int size)
#endif // _MAT_LIB_
