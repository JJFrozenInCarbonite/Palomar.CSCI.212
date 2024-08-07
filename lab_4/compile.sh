as -o main.o main.s
as -o init.o init.s
as -o display.o display.s
gcc -o program main.o init.o display.o -static
rm *.o