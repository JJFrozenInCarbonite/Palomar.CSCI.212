.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern printf

.global evaluateGuess

.text
.align 2

evaluateGuess:
    push    {lr}            // Save the link register to the stack

    // Arguments: r0 = random number, r1 = user's guess

    // Compare the user's guess with the random number
    cmp     r1, r0          // Compare r1 (user's guess) with r0 (random number)
    beq     correct         // If equal, branch to correct
    blt     too_low         // If less than, branch to too_low

too_high:
    // Print "Too high!" message
    ldr     r0, =highMsg
    bl      printf
    mov     r0, #0          // Indicate the game should continue
    pop     {lr}            // Restore the link register
    bx      lr              // Return from the function

too_low:
    // Print "Too low!" message
    ldr     r0, =lowMsg
    bl      printf
    mov     r0, #0          // Indicate the game should continue
    pop     {lr}            // Restore the link register
    bx      lr              // Return from the function

correct:
    // Print "Correct!" message
    ldr     r0, =correctMsg
    rsb     r1, r2, #8      // Calculate guesses taken
    bl      printf
    mov     r0, #1          // Indicate the game should terminate
    pop     {lr}            // Restore the link register
    bx      lr              // Return from the function

// String constants
.data
.align 4
highMsg: .asciz "Too high, guess again\n"
lowMsg: .asciz "Too low, guess again\n"
correctMsg: .asciz "You Got it! It took %d guesses.\n"

.section .note.GNU-stack,"",%progbits
