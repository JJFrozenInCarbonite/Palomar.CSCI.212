#include <stdio.h>

int main() {
    int term, a = 1, b = 1, c = 0;
    printf("Enter the term: ");
    scanf("%d", &term);

    for(int i = 1; i < term - 1; i++) {
        c = a + b;
        a = b;
        b = c;
    }

    printf("%d\n", c);

    return 0;
}