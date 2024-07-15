#include <stdio.h>

int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}   

int main() {
    int a, b;
    printf("Enter first term: ");
    scanf("%d", &a);
    printf("Enter second term: ");
    scanf("%d", &b);
    printf("The GCD is: %d\n", gcd(a, b));
    return 0;
}