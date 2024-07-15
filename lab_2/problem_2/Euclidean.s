	.arch armv7-a               @ Target architectur
    .cpu cortex-a72             @ cpu
    .fpu neon-fp-armv8          @ Floating point unit version
    .text                       @ Code section
    .align  2                   @ Align the code on a 4-byte boundary
    .global main                @ Makes the main function globally accessible
    .arm
    .type   main, %function     @ Declares 'main' as a function

.section .data
prompt1: .asciz "Enter the 1st term: "
prompt2: .asciz "Enter the 2nd term: "
printr2: .asciz "r2: %d\n"
printr3: .asciz "r3: %d\n"
result: .asciz "The GCD is: %d\n"
format: .asciz "%d"
newline: .asciz "\n"

term1: .space 4
term2: .space 4

.section .text
main:
    @ Print prompt1 to console
    ldr r0, =prompt1
    bl printf

    @ Read term1
    ldr r0, =format
    ldr r1, =term1
    bl scanf

    @ Load input into r2
    ldr r4, =term1
    ldr r4, [r4]

    @print prompt2 to console
    ldr r0, =prompt2
    bl printf

    @ Read term2
    ldr r0, =format
    ldr r1, =term2
    bl scanf

    @ Load input into r3
    ldr r5, =term2
    ldr r5, [r5]

loop:
    @ Compare r2 to r3
    cmp r5, r4
    ble skip_swap

    @ Swap values
    mov r6, r4
    mov r4, r5
    mov r5, r6

skip_swap:
    @ Divide r4 by r5 and get the remainder
    sdiv r6, r4, r5
    mls r6, r6, r5, r4
    
    @ If r4 == 0 then goto done label
    cmp r6, #0
    beq done

    @ Correctly update r2 and r3 for the next iteration
    mov r4, r5
    mov r5, r6
    b loop  @ Ensure the loop continues with the updated values

done:
    @ Print result
    ldr r0, =result
    mov r1, r5
    bl printf

    @ Exit
    mov r0, #0
    bl exit

.section .note.GNU-stack,"",%progbits
