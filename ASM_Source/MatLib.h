#ifndef _MAT_LIB_
#define _MAT_LIB_

//Predefinition of methods to let C recognize them
/*template <class data>
extern "C" int sum(data& a, data& b);*/
extern "C" float sum(float a, float b);
//extern "C" int rest(int a, int b);
extern "C" int mult(int x, int y);
extern "C" int divide(int x, int y);
extern "C" int rem(int x, int y);
extern "C" bool clean_buffer(void* buffer, unsigned int size);
extern "C" unsigned int abs_val(int val);

//Todo
extern "C" int sum_array_values(int* buffer, unsigned int size);
extern "C" void priorize_array(void* buffer);

#endif // _MAT_LIB_
