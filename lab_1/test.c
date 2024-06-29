#include <stdio.h>

int test(int n)
{
	return (n % 10);
}

int main(int argc, char *argv[]) {
    int i = 294;

    printf("The digit in the ones place of %d is %d\n", i, test(i));
    
    return 0;
}

