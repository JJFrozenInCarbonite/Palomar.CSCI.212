.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern scanf

.global promptUserGuess

.text
.align 2

promptUserGuess:
    push    {r4, lr}        // Save r4 and lr
    sub     sp, sp, #16     // Allocate stack space for variables

    // Prompt the user for input
    ldr     r0, =prompt     // Load the address of the prompt string
    bl      printf          // Call printf

    // Read the user's input
    ldr     r0, =inputFormat // Load the address of the input format string
    add     r1, sp, #8      // Use space in stack for the user's input
    bl      scanf           // Call scanf("%d", &input)

    ldr     r0, [sp, #8]    // Load the user's input from the stack into r0

    add     sp, sp, #16     // Deallocate stack space
    pop     {r4, lr}        // Restore r4 and lr
    bx      lr              // Return to the caller with the user's input in r0

// String constants
.data
.align 4
prompt: .asciz "Enter your guess >= 50 and <= 100: "
inputFormat: .asciz "%d"

.section .note.GNU-stack,"",%progbits
