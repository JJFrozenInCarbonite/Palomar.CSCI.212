@ initDeck.s
@ Initialize a deck of cards
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
    .extern pointerDeck

@ Function prototypes
    .global initDecks
    .type   initDecks, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    start:  .asciz "Initializing deck..."
    end:    .asciz " \033[92mComplete\033[0m.\n"

.text
    .align  4                       // Align text section to 4-byte boundary

@ Initialize unshuffled cardDeck
initDecks:
    push    {lr}                    // Save the return address

    ldr     r0, =start              // Load the address of the initialization message
    bl      printf                  // Print the initialization message

    ldr     r4, =cardDeck           // Load the base address of cardDeck
    ldr     r5, =pointerDeck        // Load the base address of pointerDeck
    mov     r6, #0                  // Initialize index to 0
    mov     r7, #0                  // Initialize suit index to 0

suit:
    cmp     r7, #4                  // Compare suit index to 4
    bge     exit                    // If suit counter >= 4, exit loop
    add     r7, r7, #1              // Increment suit index
    mov     r8, #0                  // Initialize value index to 0

value:
    cmp     r8, #13                 // Compare value index to 13
    bge     suit                    // If value index >= 13, go to suit_loop
    add     r8, r8, #1              // Increment value index
    add     r9, r4, r6, LSL #3      // Calculate the address of the current card
    mvn     r10, #0                 // Initialize owner to -1
    str     r8, [r9, #cardValue]    // Store value in deck
    str     r10, [r9, #cardOwner]   // Store owner in deck
    add     r11, r5, r6, LSL #2     // Calculate the address in pointerDeck
    str     r9, [r11]               // Store the pointer to the card in pointerDeck
    add     r6, r6, #1              // Increment total iteration counter
    b       value                   // Continue value loop

exit:

    ldr     r0, =end                // Load the address of the completion message
    bl      printf                  // Print the completion message

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
