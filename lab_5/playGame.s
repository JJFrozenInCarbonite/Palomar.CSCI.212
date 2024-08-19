@ printBooks.s
@ Print the user's books
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
    .extern updateBooks
    .extern updateHands
    .extern printHand
    .extern printBooks
    .extern getGuessUser
    .extern getGuessComp
    .extern printf
    
@ Function prototypes
    .global playGame
    .type   playGame, %function

.data
    .align 8                        // Align data section to 8-byte boundary
    index:    .space 4
    winMsg:   .asciz "You \033[92mwin! :-)\033[0m\n"
    loseMsg:   .asciz "You \033[91mlose! :-(\033[0mn"
    tieMsg:    .asciz "It's a tie!\n"
.text
    .align  4                       // Align text section to 4-byte boundary

@ Print user card books
playGame:

    push    {lr}                    // Save the return address
    
    ldr     r0, =index
    mov     r1, #0
    str     r1, [r0]
    
@ Check if unowned cards exist in deck, if all cards owned, end the game
playGameLoop:

    bl      getGameState            // Check the status of the game (0 = continue, 1 = end)
    cmp     r0, #1                  // Compare the return value to 1
    beq     playGameLoopEnd         // If return value = 1, end the game

    // bl      debugPrintDecks         // Debug the cardDeck and pointerDeck

    bl      updateBooks             // Update the cardBooks array
    bl      updateHands             // Update the user and computer hands
    bl      printHand               // Print the user's hand
    bl      printBooks              // Print the user's books

    //bl      debugPrintHands
    
    bl      getGuessUser            // Get the user's guess for a card

    bl      getGameState            // Check the status of the game (0 = continue, 1 = end)
    cmp     r0, #1                  // Compare the return value to 1
    beq     playGameLoopEnd         // If return value = 1, end the game

    bl      updateBooks             // Update the cardBooks array
    bl      updateHands             // Update the user and computer hands
    bl      printHand               // Print the user's hand
    bl      printBooks              // Print the user's books

    bl      getGuessComp            // Get the computer's guess for a card

    b       playGameLoop            // Loop to continue checking cards

playGameLoopEnd:

    bl      getGameWinner           // Get the winner of the game
    cmp     r0, #0                  // Compare the return value to 0
    beq     userWin                 // If return value == 0, user wins
    bgt     compWin                 // If return value > 0, computer wins
    blt     tieGame                 // If return value < 0, tie game

userWin:
    ldr     r0, =winMsg             // Load the address of the win message
    b       printMessage            // Print the win message

compWin:
    ldr     r0, =loseMsg            // Load the address of the lose message
    b       printMessage            // Print the lose message

tieGame:
    ldr     r0, =tieMsg             // Load the address of the tie message
    b       printMessage            // Print the tie message

printMessage:
    bl      printf                  // Print the message

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
