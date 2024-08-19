@ getGameWinner.s
@ Determine who won the game
@ 2024-08-17: JJ Hoffmann

@ Define Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified                  

@ Include the card struct definitions
    .include "cardStruct.s"         // Card struct definitions

@ Declare external symbols
    .extern cardBooks
    
@ Function prototypes
    .global getGameWinner
    .type   getGameWinner, %function

.data
    .align 8                        // Align data section to 8-byte boundary
.text
    .align  4                       // Align text section to 4-byte boundary

@ Print user card books
getGameWinner:

    push    {lr}                    // Save the return address

    ldr     r0, =cardBooks          // Load the address of the cardBooks
    mov     r4, #0                  // Index = 0
    mov     r5, #0                  // User book count = 0
    mov     r6, #0                  // Computer book count = 0

gameWinnerLoop:
    cmp     r4, #13                 // Compare index to 13
    bge     computeWinner           // If index >= 13, go to computeWinner
    ldr     r7, [r0, r4, LSL #2]    // Load owner from cardBooks using the index
    cmp     r7, #0                  // Compare owner to 0 (user)
    beq     userBook                // If owner == 0, go to userBook
    cmp     r7, #1                  // Compare owner to 1 (computer)
    bgt     compBook                // If owner == 1, go to compBook
    b       incrementIndex          // Loop to continue checking cards

userBook:
    add     r5, r5, #1              // Increment user book count
    b       incrementIndex          // Loop to continue checking cards

compBook:
    add     r6, r6, #1              // Increment computer book count
    b       incrementIndex          // Loop to continue checking cards

incrementIndex:
    add     r4, r4, #1              // Increment index
    b       gameWinnerLoop          // Loop to continue checking cards

computeWinner:
    cmp     r5, r6                  // Compare user book count to computer book count
    beq     tieGame                 // If equal, go to tieGame

userWin:
    mov     r0, #0                  // Set the return value to 1 (user win)
    b       exitFunction            // Go to exitFunction

compWin:
    mov     r0, #1                  // Set the return value to 2 (computer win)
    b       exitFunction

tieGame:
    mov     r0, #-1                 // Set the return value to -1 (tie)
    b       exitFunction            // Go to exitFunction

exitFunction:

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
