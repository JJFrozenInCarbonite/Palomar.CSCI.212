@ updateBooks.s
@ Update the books of cards
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern cardBooks
    .extern cardDeck

@ Function prototypes
    .global updateBooks
    .type   updateBooks, %function

.data
    .align  8                       // Align data section to 8-byte boundary
.text
    .align  4                       // Align text section to 4-byte boundary

@ Update books of cards
updateBooks:
    push    {lr}                    // Save the return address

    ldr     r4, =cardBooks          // Load the base address of cardBooks
    ldr     r5, =cardDeck           // Load the base address of cardDeck
    mov     r6, #0                  // Outer loop index

outerLoop:
    cmp     r6, #13                 // Compare outer loop index to 13
    bge     exitFunction            // If index >= 13, exit function
    mov     r7, #0                  // Inner loop index

innerLoop:
    mov     r0, #13                 // Move 13 into r0
    mla     r8, r7, r0, r6          // Calculate the index of the target card
    add     r9, r5, r8, LSL #3      // Calculate the address of the target card 
    cmp     r7, #0                  // Compare inner loop index to 0
    ldr     r10, [r9, #cardOwner]   // Store current card owner
    beq     iterateInnerLoop        // If inner loop index == 0, continue inner loop
    cmp     r10, r11                // Compare the owner of the current card to the previous card
    bne     iterateOuterLoop        // If the owners are not the same, go to next outer loop iteratiion
    cmp     r7, #3                  // Compare inner loop index to 3 
    bne     iterateInnerLoop        // If inner loop index < 3, continue inner loop 
    str     r11, [r4, r6, LSL #2]   // Store the owner of the book
    b       iterateOuterLoop        // Continue outer loop

iterateInnerLoop:
    mov     r11, r10                // Overwrite previous owner with current owner
    add     r7, r7, #1              // Increment inner loop index
    b       innerLoop               // Continue inner loop

iterateOuterLoop:
    add     r6, r6, #1              // Increment outer loop index
    b       outerLoop               // Continue outer loop

exitFunction:
    pop     {lr}                    // Restore the return address
    bx      lr                      // Return to the calling function

.section .note.GNU-stack,"",%progbits
