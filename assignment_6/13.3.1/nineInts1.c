/* nineInts1.c
 * Declares and adds nine integers.
 * 2017-09-29: Bob Plantz 
 */
#include <stdio.h>
#include "sumNine1.h"

int main(void)
{
  int total;
  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
  int g = 7;
  int h = 8;
  int i = 9;
   
  total = sumNine(a, b, c, d, e, f, g, h, i);
  printf("The sum is %i\n", total);

  return 0;
}