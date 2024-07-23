#include <stdio.h>
int letterA(void);
int letterB(void);

int main()
{
    char c;

    c = letterA();
    printf("1) %c\n", c);

    c = letterB();
    printf("2) %c\n", c);

    return 0;
}