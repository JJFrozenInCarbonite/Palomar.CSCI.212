@ goFish.s
@ The game of Go Fish
@ 2024-08-17: JJ Hoffmann

@ Define my Raspberry Pi
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Constants
    .include "cardStruct.s"  @ card struct defs.

.extern srand
.extern time

@ Function prototypes
    .global main
    .type   main, %function

@ Global variables
    .global cardBooks
    .global cardDeck
    .global pointerDeck
    .global userHand
    .global compHand

.data
    .align  8                       // Align data section to 8-byte boundary
    cardBooks:      .space 52       // Array to hold the owner of each book
    cardDeck:       .space 52 * 8   // Size of the deck (52 cards)
    pointerDeck:    .space 52 * 4   // Array to hold 52 pointers (4 bytes each)
    userHand:       .space 52 * 4   // Array to hold the user's hand (52 cards)
    compHand:       .space 52 * 4   // Array to hold the computer's hand (52 cards)
    num:            .asciz "%d\n"
    addr:           .asciz "0x%x\n"

.text
    .align  4                       // Align text section to 4-byte boundary

main:
    mov     r0, #0                  // Move 0 into r0 to pass NULL to time
    bl      time                    // time(NULL) - returns the current time in seconds since the Epoch
    bl      srand                   // srand(time(NULL))

    bl      initBooks               // Initialize the books
    bl      initDecks               // Initialize the decks
    bl      shuffleDeck             // Shuffle the pointers in pointerDeck    
    bl      dealCards               // Deal the cards to the players

    bl      playGame                // Play the game

    mov r0, #0                      // Use 0 as the exit status
    mov r7, #1                      // Correct system call number for exit
    svc 0                           // Make the system call to exit

.section .note.GNU-stack,"",%progbits
