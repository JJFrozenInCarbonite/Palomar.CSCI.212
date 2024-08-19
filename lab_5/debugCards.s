@ debugBooks.s
@ Debugging function for books
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified        

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern cardDeck
    .extern printf

@ Function prototypes
    .global debugUpdateCards
    .type   debugUpdateCards, %function

.data
    .align  8                       // Align data section to 8-byte boundary
.text
    .align  4                       // Align text section to 4-byte boundary

@ Function to debug books
debugUpdateCards:
    push    {lr}                    // Save the return address

    ldr     r4, =cardDeck           // Load the address of the cardDeck
    mov     r5, #0                  // New owner constant (0) into r5
    mov     r6, #0                  // Initialize index to 0

cardStart:
    cmp     r6, #52                 // Compare index to 52
    bge     cardEnd                 // If index >= 52, go to end
    add     r7, r4, r6, LSL #3      // Calculate the address of the current pointer
    str     r5, [r7, #cardOwner]    // Load card value from cardDeck using the address
    add     r6, r6, #1              // Increment index
    b       cardStart               // Continue loop

cardEnd:

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
