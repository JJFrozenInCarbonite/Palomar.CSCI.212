// user-defined function to check prime number
int checkPrimeNumber(int n) {
    int flag = 1;
    for(int j = 2; j <= n/2; ++j) {
        if (n % j == 0) {
            flag = 0;
            break;
        }
    }
return flag;
}