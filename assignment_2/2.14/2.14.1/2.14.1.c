#include <stdio.h>

int main() {
  char *charPtr = "CSCI 212";
  
  while (*charPtr != '\0') {
    printf("%p:  ", charPtr);
    printf("0x%02x\n", *charPtr);
    charPtr++;
  }
  
  printf("%p:  ", charPtr);
  printf("0x%02x\n", *charPtr);

  return 0;
}