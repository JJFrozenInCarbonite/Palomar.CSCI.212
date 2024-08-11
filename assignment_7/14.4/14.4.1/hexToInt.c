/* hexToInt.c
 * Converts hex character string to int.
 * 2017-09-29: Bob Plantz
 */
 
#include "hexToInt.h"
#define GAP 7
#define NO_ASCII 0xf

int hexToInt(char *stringPtr)
{
  int accumulator = 0;
  char current;

  current = *stringPtr;
  
  while (current != '\0') {
    accumulator = accumulator << 4;
    if (current > '9')     // check for alpha
      current -= GAP;
    current &= NO_ASCII;   // strip ASCII part
    accumulator += (int)current;
    stringPtr++;
    current = *stringPtr;
  }
  return accumulator;
}