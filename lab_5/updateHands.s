@ updateHand.s
@ Update the user and computer hands
@ 2024-08-18: JJ Hoffmann

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
    .extern userHand
    .extern compHand
    .extern qsort
    
@ Function prototypes
    .global updateHands
    .type   updateHands, %function

.data
    .align  8                       // Align data section to 8-byte boundary
.text
    .align  4                       // Align text section to 4-byte boundary

@ Comparison function for qsort
compare:
    push    {lr}                    // Save the return address
    ldr     r2, [r0]                // Load the first integer
    ldr     r3, [r1]                // Load the second integer
    cmp     r2, r3                  // Compare the integers
    movlt   r0, #-1                 // If r2 < r3, return -1
    movgt   r0, #1                  // If r2 > r3, return 1
    moveq   r0, #0                  // If r2 == r3, return 0
    pop     {pc}                    // Return from the function

@ Update the hands
updateHands:
    push    {lr}                    // Save the return address

    mov     r4, #0                  // Index = 0
    mov     r5, #0
@ Clear userHand Array
clearUserHandLoop:
    cmp     r4, #52                 // Compare user hand index to 52
    bge     exitClearUserHandLoop   // If index >= 52, exit user hand clear loop
    ldr     r0, =userHand           // Load the base address of userHand
    str     r5, [r0, r4, LSL #2]    // Set userHand[r4] = 0
    add     r4, r4, #1              // Increment user hand loop index
    b       clearUserHandLoop       // Continue user hand clear loop
exitClearUserHandLoop:

    mov     r4, #0                  // Index = 0

@ Clear compHand Array
clearCompHandLoop:
    cmp     r4, #52                 // Compare computer hand index to 52
    bge     exitClearCompHandLoop   // If index >= 52, exit computer hand clear loop
    ldr     r0, =compHand           // Load the base address of compHand
    str     r5, [r0, r4, LSL #2]    // Set compHand[r5] = 0
    add     r4, r4, #1              // Increment computer hand loop index
    b       clearCompHandLoop       // Continue computer hand clear loop

@ Fill userHand Array
exitClearCompHandLoop:
    mov     r4, #0                  // Deck loop index
    ldr     r5, =cardDeck           // Load the base address of cardDeck
    ldr     r6, =userHand           // Load the base address of userHand
    ldr     r7, =cardBooks          // Load the base address of cardBooks
userLoopStart:
    cmp     r4, #52                 // Compare user loop index to 52
    bge     exitUserLoop            // If index >= 52, exit user loop
    add     r8, r5, r4, LSL #3      // Calculate the address of the target card
    ldr     r9, [r8, #cardOwner]    // Load the owner of the target card
    cmp     r9, #0                  // Compare the owner of the target card to 0 (user)
    bne     iterateUserLoop         // If the owner != 0, go to iterateUserLoop
    ldr     r9, [r8, #cardValue]    // Load the value of the target card
    sub     r8, r9, #1              // Get the index of the target card in cardBooks
    ldr     r10, [r7, r8, LSL #2]   // Load the owner of the target book
    cmp     r10, #-1                // If target card book owner is unowned
    beq     addToUserHand           // Go to addToUserHand
    b       iterateUserLoop         // Otherwise, continue user loop

addToUserHand:
    str     r9, [r6, r4, LSL #2]    // Set userHand[r4] = r9
    b       iterateUserLoop         // Continue user loop

iterateUserLoop:
    add     r4, r4, #1              // Increment user loop index
    b       userLoopStart           // Continue user loop

@ Fill compHand Array
exitUserLoop:
    mov     r4, #0                  // Deck loop index
    ldr     r5, =cardDeck           // Load the base address of cardDeck
    ldr     r6, =compHand           // Load the base address of compHand
    ldr     r7, =cardBooks          // Load the base address of cardBooks

compLoopStart:
    cmp     r4, #52                 // Compare comp loop index to 52
    bge     exitCompLoop            // If index >= 52, exit comp loop
    add     r8, r5, r4, LSL #3      // Calculate the address of the target card
    ldr     r9, [r8, #cardOwner]    // Load the owner of the target card
    cmp     r9, #1                  // Compare the owner of the target card to 1 (comp)
    bne     iterateCompLoop         // If the owner != 0, go to iterateCompLoop
    ldr     r9, [r8, #cardValue]    // Load the value of the target card
    sub     r8, r9, #1              // Get the index of the target card in cardBooks
    ldr     r10, [r7, r8, LSL #2]   // Load the owner of the target book
    cmp     r10, #-1                // If target card book owner is unowned
    beq     addToCompHand           // Go to addToCompHand
    b       iterateCompLoop         // Otherwise, continue comp loop

addToCompHand:
    str     r9, [r6, r4, LSL #2]    // Set compHand[r4] = r9
    b       iterateCompLoop         // Continue comp loop

iterateCompLoop:
    add     r4, r4, #1              // Increment comp loop index
    b       compLoopStart           // Continue comp loop
exitCompLoop:

    @ Prepare arguments for qsort of userHand
    ldr     r0, =userHand           // Load the base address of userHand
    mov     r1, #52                 // Number of elements in userHand
    mov     r2, #4                  // Size of each element (4-byte integers)
    ldr     r3, =compare            // Load the address of the comparison function
    bl      qsort                   // Call qsort

    @ Prepare arguments for qsort of compHand
    ldr     r0, =compHand           // Load the base address of compHand
    mov     r1, #52                 // Number of elements in compHand
    mov     r2, #4                  // Size of each element (4-byte integers)
    ldr     r3, =compare            // Load the address of the comparison function
    bl      qsort                   // Call qsort

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return to the calling function

.section .note.GNU-stack,"",%progbits
