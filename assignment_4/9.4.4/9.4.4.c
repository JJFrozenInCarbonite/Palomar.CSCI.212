
#include <stdio.h>
int number1(void);
int number2(void);
int number3(void);

int main()
{
  int i;

  i = number1();
  printf("1) %i\n", i);

  i = number2();
  printf("2): %i\n", i);

  i = number3();
  printf("3): %i\n", i);

  return 0;
}