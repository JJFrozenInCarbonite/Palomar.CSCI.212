@ debugDecks.s
@ Debugging functions decks (card and pointer)
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern cardDeck
    .extern pointerDeck
    .extern printf

@ Function prototypes
    .global debugPrintDecks
    .type   debugPrintDecks, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    cDeck:      .asciz "  Card Deck: "
    pDeck:      .asciz "  Pointer Deck: "
    user:       .asciz "\033[92m%d\033[0m "
    computer:   .asciz "\033[91m%d\033[0m "
    unowned:    .asciz "\033[0m%d\033[0m "
    newline: .asciz "\n"
    num:   .asciz "%d\n"
.text
    .align  4                       // Align text section to 4-byte boundary

@ Function to debug decks
debugPrintDecks:
    push    {lr}                    // Save the return address

    ldr     r0, =newline
    bl      printf

    ldr     r0, =cDeck
    bl      printf

    ldr     r4, =cardDeck           // Load the address of the cardDeck
    mov     r5, #0                  // Initialize index to 0

cDeckStart:
    cmp     r5, #52                 // Compare index to 52
    bge     cDeckEnd                // If index >= 52, go to end
    add     r6, r4, r5, LSL #3      // Calculate the address of the current pointer
    ldr     r7, [r6, #cardOwner]    // Load card value from cardDeck using the address
    ldr     r1, [r6, #cardValue]    // Load card value from cardDeck using the address
    cmp     r7, #0                  // Compare owner to 0 (user)
    blt     cDeckPrintUnowned       // If owner < 0, print unowned
    beq     cDeckPrintUser          // If owner == 0, print user  
    bgt     cDeckPrintComputer      // If owner > 0, print computer

cDeckPrintUnowned:
    ldr     r0, =unowned            // Load the address of the message format
    b       cDeckPrint              // Print the message

cDeckPrintUser:
    ldr     r0, =user               // Load the address of the message format
    b       cDeckPrint              // Print the message

cDeckPrintComputer:
    ldr     r0, =computer           // Load the address of the message format
    b       cDeckPrint              // Print the message

cDeckPrint:
    bl      printf                  // Print the message
    add     r5, r5, #1              // Increment index
    b       cDeckStart              // Continue loop

cDeckEnd:
    ldr     r0, =newline
    bl      printf

    ldr     r0, =pDeck
    bl      printf

    ldr     r4, =pointerDeck           // Load the address of the cardDeck
    mov     r5, #0                     // Initialize index to 0

pDeckStart:
    cmp     r5, #52                 // Compare index to 52
    bge     pDeckEnd                // If index >= 52, go to end
    add     r6, r4, r5, LSL #2      // Calculate the address of the current pointer
    ldr     r6, [r6]                // Load the address of the current card from pointerDeck
    ldr     r7, [r6, #cardOwner]    // Load card value from cardDeck using the address
    ldr     r1, [r6, #cardValue]    // Load card value from cardDeck using the address
    cmp     r7, #0                  // Compare owner to 0 (user)
    blt     pDeckPrintUnowned       // If owner < 0, print unowned
    beq     pDeckPrintUser          // If owner == 0, print user
    bgt     pDeckPrintComputer      // If owner > 0, print computer

pDeckPrintUnowned:
    ldr     r0, =unowned            // Load the address of the message format
    b       pDeckPrint              // Print the message

pDeckPrintUser:
    ldr     r0, =user               // Load the address of the message format
    b       pDeckPrint              // Print the message

pDeckPrintComputer:
    ldr     r0, =computer           // Load the address of the message format
    b       pDeckPrint              // Print the message

pDeckPrint:
    bl      printf                  // Print the message
    add     r5, r5, #1              // Increment index
    b       pDeckStart              // Continue loop

pDeckEnd:
    ldr     r0, =newline
    bl      printf

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
