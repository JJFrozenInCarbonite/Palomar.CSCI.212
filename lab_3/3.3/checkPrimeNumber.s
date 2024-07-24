.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.text
.align 2

.global main
.extern printf
.extern scanf

.section .text
main:
    push {fp, lr}                           // Save frame pointer and link register

    // Print start message
    ldr r0, =print_start
    bl printf                               // printf("Enter two positive integers: ")

    // Read two integers
    ldr r0, =scan_format
    sub sp, sp, #8                          // Space for n1 and n2
    add r1, sp, #4                          // Address of n2
    mov r2, sp                              // Address of n1
    bl scanf                                // scanf("%d %d", &n1, &n2)

    // Print initial message
    ldr r0, =print_range
    ldr r1, [sp, #4]                        // n1
    ldr r2, [sp]                            // n2
    bl printf                               // printf("Prime numbers between %d and %d are: ", n1, n2)

    // Prime checking loop
    ldr r4, [sp, #4]                        // r4 = n1
    add r4, r4, #1                          // Start from n1 + 1
    ldr r5, [sp]                            // r5 = n2

prime_loop:
    cmp r4, r5                              // Compare current number (r4) with n2 (r5)
    bge end_loop                            // If r4 >= r5, exit loop

    // Check if r4 is a prime number
    mov r0, r4                              // Argument for checkPrimeNumber
    bl checkPrimeNumber                     // Call checkPrimeNumber function
    cmp r0, #1                              // Check if return value is 1
    bne skip_print                          // If not prime, skip printing

    // Print the prime number
    ldr r0, =print_prime
    mov r1, r4                              // Current prime number
    bl printf                               // printf("%d ", r4)

skip_print:
    add r4, r4, #1                          // Increment the number
    b prime_loop                            // Repeat the loop

end_loop:
    // Clean up stack and return from main
    add sp, sp, #8                          // Deallocate stack space for n1 and n2
    pop {fp, lr}                            // Restore frame pointer and link register
    bx lr                                   // Return from main

checkPrimeNumber:
    // Input: r0 = n
    // Output: r0 = 1 if prime, 0 if not
    cmp r0, #2                              // Check if n < 2
    blt not_prime
    beq is_prime                            // 2 is prime

    mov r1, #2                              // Start divisor from 2
check_loop:
    mul r2, r1, r1                          // r2 = r1*r1
    cmp r2, r0                              // Check if r1*r1 > n
    bgt is_prime                            // If r1*r1 > n, n is prime
    mov r3, r0                              // r3 = n
    udiv r3, r3, r1                         // r3 = n / r1
    mls r2, r3, r1, r0                      // r2 = n - (n/r1)*r1
    cmp r2, #0                              // Check if n % r1 == 0
    beq not_prime                           // If true, n is not prime
    add r1, r1, #1                          // r1++
    b check_loop                            // Repeat loop

is_prime:
    mov r0, #1                              // Return 1 (prime)
    bx lr

not_prime:
    mov r0, #0                              // Return 0 (not prime)
    bx lr

.section .rodata
print_start:
    .asciz "Enter two positive integers: "
scan_format:
    .asciz "%d %d"
print_range:
    .asciz "Prime numbers between %d and %d are: "
print_prime:
    .asciz "%d "

.section .note.GNU-stack,"",%progbits
