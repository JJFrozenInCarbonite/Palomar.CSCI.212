.arch armv7-a               @ Target architecture
.cpu cortex-a72            @ CPU
.fpu neon-fp-armv8         @ Floating point unit version
.text                      @ Code section
.align  2                  @ Align the code on a 4-byte boundary
.global number3               @ Makes the number3 function globally accessible
.arm
.type   number3, %function    @ Declares 'number3' as a function

.section .text
number3:
    mov r0, #3             @ Set return value to 3
    bx lr                  @ Return from number3
