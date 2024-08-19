@ dealCards.s
@ Deal the cards to the players
@ 2024-08-17: JJ Hoffmann

@ Define my Raspberry Pi
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Include the card struct definitions
    .include "cardStruct.s"  @ card struct defs.

@ Declare external symbols
    .extern pointerDeck
    .extern printf

@ Function prototypes
    .global dealCards
    .type   dealCards, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    start:  .asciz "Dealing cards..."
    end:    .asciz " \033[92mComplete\033[0m.\n"
.text
    .align  4              // Align text section to 4-byte boundary

@ Deal the cards to the players
dealCards:
    push    {lr}                    // Save the return address

    ldr     r0, =start              // Load the address of the shuffling message
    bl      printf                  // Print the shuffling message

    ldr     r4, =pointerDeck        // Load the address of deck
    mov     r5, #0                  // Index

loop:
    cmp     r5, #13                 // Compare index to 13
    bge     exit                    // If index >= 13, exit loop
    add     r6, r4, r5, LSL #2      // Calculate the address of the current card pointer
    ldr     r7, [r6]                // Load the pointer to the current card in cardDeck
    tst     r5, #1                  // Check if index is odd
    beq     user                    // If index is even, go to user
    bne     computer                // If index is odd, go to computer

user:
    mov     r8, #0                  // r7 = 0
    b       update                  // Go to updateCard
computer:
    mov     r8, #1                  // r7 = 1
    b       update                  // Go to updateCard

update:
    str     r8, [r7, #cardOwner]    // Store owner in deck
    add     r5, r5, #1              // Increment index
    b       loop                    // Continue loop
    
exit:

    ldr     r0, =end                // Load the address of the complete message
    bl      printf                  // Print the complete message

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return to the calling function

.section .note.GNU-stack,"",%progbits
