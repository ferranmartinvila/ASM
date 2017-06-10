#include <stdio.h>
#include "mtbl.h"

void main()
{
    // Comprovo el funcionament amb majúscules
    mchar_t m1 = mtbl_a2m('A');
    mchar_t m2 = mtbl_a2m('B');
    mchar_t m3 = mtbl_a2m('Z');

    char c1 = mtbl_m2a(m1);
    char c2 = mtbl_m2a(m2);
    char c3 = mtbl_m2a(m3);

    printf("%c %d ", c1, m1);
    printf("%c %d ", c2, m2);
    printf("%c %d \n", c3, m3);

    // Comprovo el funcionament amb minúscules
    mchar_t m4 = mtbl_a2m('a');
    mchar_t m5 = mtbl_a2m('b');
    mchar_t m6 = mtbl_a2m('z');

    char c4 = mtbl_m2a(m4);
    char c5 = mtbl_m2a(m5);
    char c6 = mtbl_m2a(m6);

    printf("%c %d ", c1, m1);
    printf("%c %d ", c2, m2);
    printf("%c %d \n", c3, m3);

    // Comprovo el funcionament amb números
    mchar_t m7 = mtbl_a2m('0');
    mchar_t m8 = mtbl_a2m('1');
    mchar_t m9 = mtbl_a2m('9');

    char c7 = mtbl_m2a(m7);
    char c8 = mtbl_m2a(m8);
    char c9 = mtbl_m2a(m9);

    printf("%c %d ", c7, m7);
    printf("%c %d ", c8, m8);
    printf("%c %d \n", c9, m9);

    // Comprovo el funcionament amb espai i indefinits
    mchar_t m10 = mtbl_a2m(' ');
    mchar_t m11 = mtbl_a2m('@');
    mchar_t m12 = mtbl_a2m('\n');

    char c10 = mtbl_m2a(m10);
    char c11 = mtbl_m2a(m11);
    char c12 = mtbl_m2a(m12);

    printf("%c %d ", c10, m10);
    printf("%c %d ", c11, m11);
    printf("%c %d \n", c12, m12);
}
