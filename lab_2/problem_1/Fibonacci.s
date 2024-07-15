	.arch armv6                 @ Target architectur
    .fpu vfp                    @ Floating point unit version
    .text                       @ Code section
    .align  2                   @ Align the code on a 4-byte boundary
    .global main                @ Makes the main function globally accessible
    .arm
    .type   main, %function     @ Declares 'main' as a function

.section .data
prompt: .asciz "Enter the term: "
format: .asciz "%d"
newline: .asciz "\n"

term: .word 0
a: .word 1
b: .word 1
c: .word 0

.section .text
main:
    @ Print prompt to console
    ldr r0, =prompt
    bl printf

    @ Read term for user
    ldr r0, =format
    ldr r1, =term
    bl scanf

    @ Set r4 equal to user input for loop termination
    ldr r4, =term
    ldr r4, [r4]
    
    @ Set r1, r2 to a, b
    ldr r1, =a
    ldr r2, =b
    ldr r1, [r1]
    ldr r2, [r2]

    @ Check if term <= 2
    cmp r4, #2
    ble done

    @ Adjust loop count (term - 1)
    sub r4, r4, #1

loop:
    add r3, r1, r2  @ c = a + b
    mov r1, r2      @ a = b
    mov r2, r3      @ b = c

    @ Decrement loop counter and check loop condition
    subs r4, r4, #1
    bne loop

done:
    @ Print c
    ldr r0, =format
    mov r1, r3
    bl printf

    ldr r0, =newline
    bl printf

    @ Exit
    mov r0, #0
    bl exit

.section .note.GNU-stack,"",%progbits
f