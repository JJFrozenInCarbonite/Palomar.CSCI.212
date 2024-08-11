#!/bin/bash

# Define the input file
input_file="nineInts1.c"

# Define the base name for the output files
base_name="13.3.1"

# Compile with optimization level -O1
gcc -O1 -S "$input_file" -o "${base_name}-O1.s"

# Compile with optimization level -O2
gcc -O2 -S "$input_file" -o "${base_name}-O2.s"

# Compile with optimization level -O3
gcc -O3 -S "$input_file" -o "${base_name}-O3.s"

echo "Assembly files generated with optimization levels -O1, -O2, and -O3."