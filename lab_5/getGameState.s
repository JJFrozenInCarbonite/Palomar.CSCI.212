@ getGameState.s
@ Get the state of the game
@ 2024-08-17: JJ Hoffmann

@ Define Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified                  

@ Include the card struct definitions
    .include "cardStruct.s"         // Card struct definitions

@ Declare external symbols
    .extern cardDeck
    
@ Function prototypes
    .global getGameState
    .type   getGameState, %function

.data
    .align 8                        // Align data section to 8-byte boundary
.text
    .align  4                       // Align text section to 4-byte boundary

@ Determine if all cards are owned, if so end the game
@ 0 = continue game, 1 = end game
getGameState:

    push    {lr}                    // Save the return address

    ldr     r0, =cardDeck          // Load the address of the cardDeck\
    mov     r4, #0                  // Index = 0
    mov     r5, #0                  // Return value = 0 

@ Check if unowned cards exist in deck, if all cards owned, end the game
stateCheck:
    cmp     r4 , #52                // Compare index to 52
    bge     setStateEnd             // If index >= 52, to to setStateEnd
    add     r6, r0, r4, LSL #3      // Calculate the address of the current pointer
    ldr     r7, [r6, #cardOwner]    // Load card value from cardDeck using the address
    cmp     r7, #-1                 // Compare owner to -1 (unowned)
    beq     exitFunction
    add     r4, r4, #1              // Increment index
    b       stateCheck              // Loop to continue checking cards

setStateEnd:
    mov     r5, #1                  // Set return value to 1 (end game)
    b       exitFunction            // Exit function
    
exitFunction:
    mov     r0, r5                  // Move the return value to r0

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
