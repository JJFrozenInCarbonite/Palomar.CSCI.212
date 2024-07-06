/* echoLine1.c
 * Echoes a line entered by the user.
 * 2017-09-29: Bob Plantz
 */

#include <unistd.h>

int main(void)
{
    char aLetter;
    char lineBuffer[256]; // Buffer to store the line, adjust size as needed
    int i = 0; // Index for the buffer

    write(STDOUT_FILENO, "Enter a line: ", 14); // Prompt user

    while (1) {
        read(STDIN_FILENO, &aLetter, 1); // Read one character
        if (aLetter == '\n') { // Check for newline character
            break; // Exit the loop if newline is found
        }
        lineBuffer[i++] = aLetter; // Store the character in the buffer
        if (i >= sizeof(lineBuffer) - 1) { // Check buffer overflow
            break; // Prevent buffer overflow
        }
    }
    lineBuffer[i] = '\0'; // Null-terminate the string

    write(STDOUT_FILENO, "You entered: ", 13); // Message
    write(STDOUT_FILENO, lineBuffer, i); // Echo the line

    

    return 0;
}