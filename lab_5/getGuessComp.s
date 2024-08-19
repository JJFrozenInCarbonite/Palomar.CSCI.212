@ getGuessComp.s
@ Get the computer's guess
@ 2024-08-18: JJ Hoffmann

@ Define Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified                  

@ Include the card struct definitions
    .include "cardStruct.s"         // Card struct definitions

@ Declare external symbols
    .extern cardDeck
    .extern pointerDeck
    .extern compHand
    .extern printHand
    
@ Function prototypes
    .global getGuessComp
    .type   getGuessComp, %function

.data
    .align 8                        // Align data section to 8-byte boundary
    askForCardMsg:  .asciz "\n\033[93mComputer:\033[0m Do you have any %d's?"    
    lostCardMsg:    .asciz "\n\033[91mBummer!\033[0m The computer took a %d.\n"
    lostCardsMsg:   .asciz "\n\033[91mBummer!\033[0m The computer took %d %d's.\n"
    goFishMsg:      .asciz "\n\033[96mGo Fish!\033[0m The computer drew a card from the deck.\n"
    drawCardErrorMsg:   .asciz "\n\033[91mError!\033[0m No unowned cards left in the deck.\n"
.text
    .align  4                       // Align text section to 4-byte boundary

@ The computer tried for a card
getGuessComp:

    push    {lr}                    // Save the return address

    ldr     r4, =compHand           // Load the address of compHand
    mov     r5, #52                 // Last position in the compHand

randomCard:
    bl      rand                    // Call rand(), result in r0
    udiv    r6, r0, r5              // r6 = r0 / r5 (quotient)
    mls     r7, r6, r5, r0          // r7 = r0 - (r6 * r5) (remainder, effectively r0 % r5)
    ldr     r8, [r4, r7, LSL #2]    // Load the card value from the hand
    cmp     r8, #0                  // Compare r3 to 0
    beq     randomCard              // If r3 = 0, repeat the loop
    mov     r4, r8                  // Move the random card value to r4
    ldr     r5, =cardDeck           // Load the address of cardDeck
    mov     r6, #0                  // Index = 0
    mov     r7, #0                  // Card count
    ldr     r0, =askForCardMsg      // Load the address of the askForCardMsg
    mov     r1, r4                  // Move the card value to r1
    bl      printf                  // Print the askForCardMsg

checkOwner:
    cmp     r6, #4                  // Compare index to 4
    bge     checkOwnerEnd           // If index >= 4, go to end
    mov     r1, #13                 // r8 = 13 (number of cards in each suit)
    sub     r2, r4, #1              // Subtract 1 from card face value to get array index
    mla     r2, r6, r1, r2          // Calculate the address of the current pointer
    add     r8, r5, r2, LSL #3      // Calculate the address of the current pointer
    ldr     r9, [r8, #cardValue]    // Load cardValue from cardDeck using the index
    cmp     r4, r9                  // Compare user input to card value
    bne     incrementCheckOwner     // If the card values don't match, increment the index
    ldr     r10, [r8, #cardOwner]   // Load cardOwner from cardDeck using the index
    cmp     r10, #0                 // Compare cardOwner to 0 (user)
    beq     assignCompAsOwner       // If owner = 0, assign the card to the computer
    b       incrementCheckOwner     // If the owner != 0, increment the index

assignCompAsOwner:
    mov     r10, #1                 // Assign the computer as the owner
    str     r10, [r8, #cardOwner]   // Store the owner in the cardDeck
    add     r7, r7, #1              // Increment the card count
    b       incrementCheckOwner     // Increment the index

incrementCheckOwner:
    add     r6, r6, #1              // Increment the index
    b       checkOwner              // Continue the loop

checkOwnerEnd:
    cmp     r7, #1                  // Compare the card count to 1
    blt     drawCard                // If the card count = 0, go to drawCard
    beq     lostCard                 // If the card count = 1, go to gotCard
    bgt     lostCards                // If the card count > 1, go to gotCards

lostCard:
    ldr     r0, =lostCardMsg        // Load the address of the lostCardMsg
    mov     r1, r4                  // Move the card value to r1
    bl      printf                  // Print the lostCardMsg
    b       exitFunction            // Go to exitFunction

lostCards:
    ldr     r0, =lostCardsMsg       // Load the address of the lostCardsMsg
    mov     r1, r7                 // Move the card count to r1
    mov     r2, r4                  // Move the card value to r2
    bl      printf                  // Print the lostCardsMsg
    b       exitFunction            // Go to exitFunction

drawCard:
    ldr     r5, =pointerDeck        // Load the address of pointerDeck
    mov     r6, #0                  // Index = 0

drawCardLoop:
    cmp     r6, #52                 // Compare the index to 52
    bge     drawCardError           // If the index >= 52, go to drawCardError
    add     r7, r5, r6, LSL #2      // Calculate the address of the current pointer
    ldr     r7, [r7]                // Load the address of the current card from pointerDeck
    ldr     r8, [r7, #cardOwner]    // Load the owner of the card
    ldr     r9, [r7, #cardValue]    // Load the value of the card
    cmp     r8, #-1                 // Compare the owner to -1 (unowned)
    beq     putCardInHand           // If the owner = -1, put the card in the computer's hand
    add     r6, r6, #1              // Increment the index
    b       drawCardLoop            // Continue loop

putCardInHand:
    ldr     r0, =goFishMsg          // Load the address of the goFishMsg
    mov     r1, r9                  // Move the card value to r1
    bl      printf                  // Print the goFishMsg
    mov     r9, #1                  // r9 = 1 (computer)
    str     r9, [r7, #cardOwner]    // Assign computer as cardOwner
    b       exitFunction            // Go to exitFunction

drawCardError:
    ldr     r0, =drawCardErrorMsg   // Load the address of the drawCardError
    bl      printf                  // Print the drawCardError
    b       exitFunction            // Go to exitFunction

exitFunction:

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
