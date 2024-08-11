.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .data
format: .asciz "%d"
num_prompt: .asciz "Numerator: "
num_value: .word 0
denom_prompt: .asciz "Denominator: "
denom_value: .word 0

.section .text
.global fractionInput

.extern printf
.extern scanf

fractionInput:
    @ Save the return address
    push {lr}

    @ Align the stack to 8 bytes for scanf and printf
    sub sp, sp, #4

    @ Prompt for the numerator
    ldr r0, =num_prompt
    bl printf

    @ Read the numerator
    ldr r0, =format      @ Load the format string into r0
    ldr r1, =num_value   @ Load the address of num_value into r1
    bl scanf             @ Call scanf

    @ Load the numerator value into r0
    ldr r0, =num_value
    ldr r0, [r0]

    @ Prompt for the denominator
    ldr r0, =denom_prompt
    bl printf

    @ Read the denominator
    ldr r0, =format      @ Load the format string into r0
    ldr r1, =denom_value @ Load the address of denom_value into r1
    bl scanf             @ Call scanf

    @ Load the denominator value into r1
    ldr r1, =denom_value
    ldr r1, [r1]

    @ Restore the stack and return
    add sp, sp, #4       @ Restore stack alignment
    pop {lr}
    bx lr

.section .note.GNU-stack,"",%progbits
