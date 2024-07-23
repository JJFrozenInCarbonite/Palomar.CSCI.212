.arch armv7-a               @ Target architecture
.cpu cortex-a72            @ CPU
.fpu neon-fp-armv8         @ Floating point unit version
.text                      @ Code section
.align  2                  @ Align the code on a 4-byte boundary
.global main               @ Makes the main function globally accessible
.arm
.type   main, %function    @ Declares 'main' as a function

.section .text
main:
    mov r0, #123             @ Set return value to 0
    bx lr                  @ Return from main

.section .note.GNU-stack,"",%progbits
