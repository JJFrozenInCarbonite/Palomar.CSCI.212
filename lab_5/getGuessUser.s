@ getGuessUser.s
@ Get the user's guess
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
    .extern userHand
    .extern printHand
    
@ Function prototypes
    .global getGuessUser
    .type   getGuessUser, %function

.data
    .align 8                        // Align data section to 8-byte boundary
    userInput:      .word 4
    userPromptMsg:      .asciz "\nEnter a card value: "
    notAnIntMsg:        .asciz "\033[91mError!\033[0m Only whole numbers accepted.\n"
    invalidChoiceMsg:   .asciz "\033[91mError!\033[0m Not a valid card value You can only ask for a card currently in your hand.\n"
    gotCardMsg:         .asciz "\n\033[92mNice!\033[0m You received a(n) %d from the computer!\n"
    gotCardsMsg:        .asciz "\n\033[92mNice!\033[0m You received %d %d's from the computer!\n"
    goFishMsg:          .asciz "\n\033[96mGo Fish!\033[0m. You drew a %d from the deck.\n"
    drawCardErrorMsg:   .asciz "\033[91mError!\033[0m No unowned cards left in the deck.\n"
    emptyHandMsg:       .asciz "\033[93mYikes!\033[0m You have no cards in your hand!\n"
    inputFormat:        .asciz "%d"
.text
    .align  4                       // Align text section to 4-byte bounary

@ Let the user try for a card
getGuessUser:

    push    {lr}                    // Save the return address

    ldr     r4, =userHand           // Load the address of userHand
    mov     r5, #0                  // Initialize index to 0
checkForEmptyHand:
    cmp     r5, #52                 // Compare index to 52
    bge     emptyHand               // If index >= 52, go to emptyHand
    ldr     r6, [r4, r5, LSL #2]    // Load the card value from userHand using the index
    cmp     r6, #0                  // Compare card value to 0
    bne     inputStart              // If card value !=0, go to inputStart
    add     r5, r5, #1              // Increment index
    b       checkForEmptyHand       // Continue loop

emptyHand:
    ldr     r0, =emptyHandMsg       // Load the address of the noCards
    bl      printf                  // Print the noCards
    b       drawCard                // Go to drawCard

inputStart:
    ldr     r0, =userPromptMsg      // Load the address of the userPrompt
    bl      printf                  // Print the user prompt message

    ldr     r0, =inputFormat        // Load the address of the userInput
    ldr     r1, =userInput          // Load the address of the userInput
    bl      scanf                   // Read the user input

    cmp     r0, #1                  // Compare the return value to 1
    beq     checkValidChoice        // If equal, go to checkValidChoice
    b       notAnInt                // Otherwise, go to notAnInt

notAnInt:
    ldr     r0, =notAnIntMsg        // Load the address of the notAnIntMsg
    bl      printf                  // Print the notAnIntMsg
    b       clearInputBuffer        // Clear the input buffer

clearInputBuffer:
    mov     r0, #0                  // Clear r0
    bl      getchar                 // Read a character from stdin
    cmp     r0, #10                 // Compare the character to newline ('\n')
    bne     clearInputBuffer        // If not newline, continue clearing buffer
    b       inputStart              // Go back to inputStart

checkValidChoice:
    ldr     r1, =userInput          // Ensure r1 is correctly initialized
    ldr     r4, [r1]                // Load the user input value from userInput
    ldr     r5, =userHand           // Load the address of the userHand
    mov     r6, #0                  // Initialize index to 0

validationLoop:
    cmp     r6, #52                 // Compare index to 52
    bge     invalidChoice           // If index >= 52, go to validChoice
    ldr     r7, [r5, r6, LSL #2]    // Load card value from userHand using the index
    cmp     r7, #0                  // Compare card value to 0
    beq     incrementValidationLoop // If card value == 0, go to incrementValidationLoop
    cmp     r4, r7                  // Compare user input to card value
    beq     validChoice             // If equal, go to validChoice
    bne     incrementValidationLoop // Otherwise, go to incrementValidationLoop

incrementValidationLoop:
    add     r6, r6, #1              // Increment index
    b       validationLoop          // Loop to continue checking cards

invalidChoice:
    ldr     r0, =invalidChoiceMsg   // Load the address of the notAnIntMsg
    bl      printf                  // Print the notAnIntMsg
    bl      printHand               // Print the user's hand
    b       clearInputBuffer        // Go back to inputStart

validChoice:
    ldr     r5, =cardDeck           // Load the address of the cardDeck
    mov     r6, #0                  // Index = 0
    mov     r7, #0                  // New card count = 0

cardDeckLoop:
    cmp     r6, #4                  // Compare index to 4
    bge     cardDeckEnd             // If index >= 4, go to cardDeckEnd
    mov     r1, #13                 // r8 = 13 (number of cards in each suit)
    sub     r2, r4, #1              // Subtract 1 from card face value to get array index
    mla     r2, r6, r1, r2          // Calculate the address of the current pointer
    add     r8, r5, r2, LSL #3      // Calculate the address of the current pointer
    ldr     r9, [r8, #cardValue]    // Load cardValue from cardDeck using the index
    cmp     r4, r9                  // Compare user input to card value
    bne     incrementCardDeckLoop   // If not equal, go to incrementCardDeckLoop
    ldr     r10, [r8, #cardOwner]   // Load cardOwner from cardDeck using the index
    cmp     r10, #1                 // Compare cardOwner to 1 (computer)
    beq     assignUserAsOwner       // If equal, go to assignUserAsOwner
    b       incrementCardDeckLoop   // Otherwise, go to incrementCardDeckLoop

assignUserAsOwner:
    mov     r10, #0                 // r8 = 0 (user)
    str     r10, [r8, #cardOwner]   // Assign user as cardOwner
    add     r7, r7, #1              // Increment card count
    b       incrementCardDeckLoop   // Go to incrementCardDeckLoop

incrementCardDeckLoop:
    add     r6, r6, #1              // Increment index
    b       cardDeckLoop            // Continue loop

cardDeckEnd:
    cmp     r7, #1                  // Compare sentinel to 0
    blt     drawCard                // If sentinel == 0, go to drawCard
    beq     gotCard                 // If card count == 1, go to gotCard
    bgt     gotCards                // If card count > 1, go to gotCards

gotCard:
    ldr     r0, =gotCardMsg         // Load the address of the gotCardMsg
    mov     r1, r4                  // Move the card value to r1
    bl      printf                  // Print the gotCardsMsg
    b       exitFunction            // Go to exitFunction

gotCards:
    ldr     r0, =gotCardsMsg        // Load the address of the gotCardsMsg
    mov     r1, r7                  // Move the card count to r1
    mov     r2, r4                  // Move the card value to r2
    bl      printf                  // Print the gotCardsMsg
    b       exitFunction            // Go to exitFunction

drawCard:   
    ldr     r5, =pointerDeck        // Load the address of the pointerDeck
    mov     r6, #0                  // Index = 0

drawCardLoop:
    cmp     r6, #52                 // Compare index to 52
    bge     drawCardError           // If index >= 52, go to drawCardError
    add     r7, r5, r6, LSL #2      // Calculate the address of the current pointer
    ldr     r7, [r7]                // Load the address of the current card from pointerDeck
    ldr     r8, [r7, #cardOwner]    // Load cardOwner from pointerDeck using the index
    ldr     r9, [r7, #cardValue]    // Load cardValue from pointerDeck using the index
    cmp     r8, #-1                 // Compare cardOwner to -1 (unowned)
    beq     putCardInHand           // If equal, go to putCardInHard
    add     r6, r6, #1              // Increment index
    b       drawCardLoop            // Continue loop

putCardInHand:
    ldr     r0, =goFishMsg          // Load the address of the goFishMsg
    mov     r1, r9                  // Move the card value to r1
    bl      printf                  // Print the goFishMsg
    mov     r9, #0                  // r9 = 0 (user)
    str     r9, [r7, #cardOwner]    // Assign user as cardOwner
    b       exitFunction            // Go to exitFunction

drawCardError:
    ldr     r0, =drawCardErrorMsg   // Load the address of the drawCardError
    bl      printf                  // Print the drawCardError
    b       exitFunction            // Go to exitFunction

exitFunction:

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
