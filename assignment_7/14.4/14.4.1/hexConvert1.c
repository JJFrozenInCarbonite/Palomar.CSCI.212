/* hexConvert1.c
 * Prompts user for hex number and converts
 * it to an int.
 * 2017-09-29: Bob Plantz
 */

#include <stdio.h> 
#include "hexToInt.h"
int writeStr(char *);
int readLn(char *, int);

int main()
{
  int theNumber;
  char theString[9];
  
  writeStr("Enter up to 32-bit hex number: ");
  readLn(theString, 9);
  theNumber = hexToInt(theString);

  printf("The integer is: %i\n", theNumber);

  return 0;
}