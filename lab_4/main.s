.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.global main                // Main function label
.global piles               // Make piles globally accessible
.global size                // Make size globally accessible

.extern deal                // Declare deal as an external function

.data
piles: .zero 180            // Space for up to 45 piles, globally defined for access in other modules
size: .word 45              // Total number of cards to distribute, defined once and used across modules

.text

main:
    bl seed                 // Call the seed function
    bl deal                 // Call the deal function
    bl play                 // Call the play function

    // Exit the program
    mov r0, #0              // Use 0 as the exit status
    mov r7, #1              // Correct system call number for exit
    svc 0                   // Make the system call to exit

.section .note.GNU-stack,"",%progbits
