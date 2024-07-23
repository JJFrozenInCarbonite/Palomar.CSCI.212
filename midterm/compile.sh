#!/bin/bash

# Find all .s files in the current directory and compile them into .o files
for file in *.s; do
    gcc -c "$file" -o "${file%.s}.o"
done

# Compile all .o files into an executable named main
gcc *.o -o main

# Remove all .o files
rm *.o