/* 2.16.3.c
 * Echoes a line entered by the user.
 * 2024-07-05: JJ Hoffmann
 */

#include <unistd.h>

int writeStr(const char *str) {
    int len = 0;
    while (str[len] != '\0') {
        len++;
    }
    write(1, str, len);
    return len;
}

int readLn(char *str, int maxLen) {
    int len = 0;
    char ch;
    while (len < maxLen - 1) {
        read(0, &ch, 1);
        if (ch == '\n') {
            break;
        }
        str[len] = ch;
        len++;
    }
    str[len] = '\0';
    return len;
}

int main() {
    char input[100];
    int len;
    
    while (1) {
        writeStr("Enter a line of text: ");
        len = readLn(input, sizeof(input));
        if (len == 0) {
            break;
        }
        writeStr("You entered: ");
        writeStr(input);
        writeStr("\n");
    }
    
    return 0;
}