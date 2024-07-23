.arch armv7-a               @ Target architecture
.cpu cortex-a72            @ CPU
.fpu neon-fp-armv8         @ Floating point unit version
.text                      @ Code section
.align  2                  @ Align the code on a 4-byte boundary
.global number1               @ Makes the number1 function globally accessible
.arm
.type   number1, %function    @ Declares 'number1' as a function

.section .text
number1:
    mov r0, #1             @ Set return value to 1
    bx lr                  @ Return from number1
