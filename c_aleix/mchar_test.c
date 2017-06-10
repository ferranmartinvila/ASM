#include <stdio.h>
#include "mchar.h"

void print_morse(mchar_t m) {
    mchar_iter_t i = mchar_iter(m);

    while (mchar_valid(i)) {
        if (mchar_next(&i) == MDot)
            printf(".");
        else
            printf("-");
    }

    printf(" ");
}

void main()
{
    mchar_t m1 = mchar_add(mchar(10), MDash); // 101
    mchar_t m2 = mchar_add(m1, MDot); // 1010
    mchar_t m3 = mchar_add(m2, MDash); // 10101
    mchar_t m4 = mchar_add(m3, MDash); // ERROR
    printf("%d , %d , %d , %d \n", m1, m2, m3, m4);

    print_morse(m1);
    print_morse(m2);
    print_morse(m3);
}
