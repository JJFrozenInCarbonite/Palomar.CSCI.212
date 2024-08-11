/* sumNine1.c
 * Computes sum of nine integers.
 * 2017-09-29: Bob Plantz 
 */
#include <stdio.h>
#include "sumNine1.h"

int sumNine(int one, int two, int three, int four, int five,
           int six, int seven, int eight, int nine)
{
  int x;

  x = one + two + three + four + five + six
            + seven + eight + nine;
  return x;