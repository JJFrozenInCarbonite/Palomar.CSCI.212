// ======================================================================
// Program: Guessing Game
// Author: JJ Hoffmann
// Date Created: 2024-07-22
// Description: This assembly program implements a simple guessing game
//              where the user is prompted to guess a randomly generated
//              number within a certain number of attempts. The game
//              provides feedback on the number of attempts remaining and
//              informs the user if they have won or lost the game.
// ======================================================================

.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern seedRandomNumberGenerator
.extern generateRandomNumber
.extern promptUserGuess
.extern evaluateGuess
.extern printf

.global main

.text
.align 2

main:
    push    {r4, r5, r6, lr} // Save r4, r5, r6, and lr
    sub     sp, sp, #16      // Allocate stack space for variables

    // Seed the random number generator
    bl      seedRandomNumberGenerator // Call the function to seed the RNG
    bl      generateRandomNumber // Call generateRandomNumber
    mov     r4, r0          // Move the random number to r4
    mov     r5, #7          // Set number of attempts

    // Print the welcome message
    ldr     r0, =welcomeMsg 
    bl      printf

loop:
    mov     r1, r5
    ldr     r0, =guessCntMsg 
    bl      printf

    // Prompt the user for a guess
    bl      promptUserGuess  // Call promptUserGuess
    mov     r6, r0           // Store the user's guess in r6

    // Evaluate the user's guess
    mov     r0, r4           // Move the random number to r0
    mov     r1, r6           // Move the user's guess to r1
    mov     r2, r5           // Move the iteration count to r2
    bl      evaluateGuess    // Call evaluateGuess

    cmp     r0, #1           // Check if the guess was correct (evaluateGuess returns 1 if correct)
    beq     end_game         // If r0 == 1, branch to end_game

    // Decrement the number of attempts
    subs    r5, r5, #1       // Decrement the loop counter
    bne     loop             // If r5 != 0, repeat the loop

    // If out of attempts, print game over message
    ldr     r0, =gameOverMsg // Load the address of gameOverMsg
    bl      printf           // Print game over message

end_game:
    add     sp, sp, #16      // Deallocate stack space
    pop     {r4, r5, r6, lr} // Restore r4, r5, r6, and lr
    mov     r0, #0           // Return 0 from main
    bx      lr               // Return from main

// String constants
.data
.align 4
welcomeMsg: .asciz "We're playing a guessing game!\n" // Welcome message displayed at the start
guessCntMsg: .asciz "Guesses Remaining: %d\n"         // Format string for displaying remaining guesses
gameOverMsg: .asciz "YOU LOSE\n"                      // Message displayed when the user runs out of guesses

.section .note.GNU-stack,"",%progbits
