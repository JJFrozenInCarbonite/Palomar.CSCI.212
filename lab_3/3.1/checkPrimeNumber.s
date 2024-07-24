.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.text
.align 2

.global checkPrimeNumber

checkPrimeNumber:
    push {lr}             // Save link register
    cmp r0, #2            // Compare n with 2
    blt not_prime         // If n < 2, it's not prime
    beq is_prime          // If n == 2, it's prime

    mov r1, #2            // Initialize j = 2
    udiv r2, r0, r1       // Calculate n/2 and store it in r2

loop:
    udiv r3, r0, r1       // Divide n by j (r1)
    mls r4, r3, r1, r0    // r4 = n - (n/j)*j to get remainder
    cmp r4, #0            // Check if remainder is 0
    beq not_prime         // If remainder is 0, n is not prime
    add r1, r1, #1        // Increment j
    cmp r1, r2            // Compare j with n/2
    ble loop              // If j <= n/2, continue loop

is_prime:
    mov r0, #1            // Set return value to 1 (prime)
    pop {pc}              // Restore pc, return

not_prime:
    mov r0, #0            // Set return value to 0 (not prime)
    pop {pc}              // Restore pc, return

.section .note.GNU-stack,"",%progbits
