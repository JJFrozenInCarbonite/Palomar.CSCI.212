gcc -c checkPrimeNumber.c -o checkPrimeNumber.o
as -o main.o checkPrimeNumber.s
gcc -o main main.o checkPrimeNumber.o
rm *.o