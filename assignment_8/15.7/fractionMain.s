.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.include "fractionStruct.s"

.section .data
fraction1: .space 8    @ Reserve 8 bytes for the fraction struct (assuming 4 bytes for numerator and 4 bytes for denominator)

.section .text
.global main

.extern fractionInput
.extern fractionConstruct
.extern fractionAdd
.extern fractionPrint

main:
    @ Call fractionInput
    bl fractionInput
    mov r2, r1        @ Move the denominator to r2
    mov r1, r0        @ Move the numerator to r1

    @ Allocate space for the fraction struct and load its address into r2
    ldr r0, =fraction1
    bl fractionConstruct

    @ Call fractionAdd
    mov r1, #1         @ Add 1 to the fraction
    bl fractionAdd

    @ Call fractionPrint
    bl fractionPrint

    @ Exit the program
    mov r7, #1         @ syscall number for exit
    mov r0, #0         @ exit code 0
    svc 0              @ make syscall

.section .note.GNU-stack,"",%progbits
