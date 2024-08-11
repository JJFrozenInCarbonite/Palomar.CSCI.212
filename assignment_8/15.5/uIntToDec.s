.arch   armv7-a
.cpu    cortex-a53
.fpu    neon-fp-armv8
.syntax unified

.global uIntToDec
.section .text

uIntToDec:
    // Save registers and set up stack frame
    push    {r4-r7, lr}      @ save r4-r7 and lr
    mov     r4, r0           @ save the integer value in r4
    mov     r5, r1           @ save the buffer pointer in r5

    // Initialize variables
    mov     r6, #10          @ divisor for modulo operation
    mov     r7, #0           @ initialize digit count to 0

convert_loop:
    udiv    r1, r4, r6       @ r1 = r4 / 10
    mls     r2, r1, r6, r4   @ r2 = r4 - (r1 * 10) (r2 = r4 % 10)
    add     r2, r2, #48      @ convert digit to ASCII ('0' + digit)
    strb    r2, [r5, r7]     @ store digit in buffer
    add     r7, r7, #1       @ increment digit count
    mov     r4, r1           @ update r4 with the quotient
    cmp     r4, #0           @ check if quotient is 0
    bne     convert_loop     @ if not, continue loop

    // Reverse the string
    sub     r5, r5, r7       @ point to the start of the buffer
    sub     r7, r7, #1       @ adjust digit count for indexing
reverse_loop:
    ldrb    r1, [r5, r7]     @ load digit from end
    ldrb    r2, [r5]         @ load digit from start
    strb    r1, [r5]         @ store end digit at start
    strb    r2, [r5, r7]     @ store start digit at end
    add     r5, r5, #1       @ move start pointer forward
    sub     r7, r7, #2       @ move end pointer backward
    cmp     r7, #0           @ check if pointers have crossed
    bge     reverse_loop     @ if not, continue loop

    // Null-terminate the string
    add     r5, r5, r7       @ point to the end of the string
    add     r5, r5, #1       @ move to the next position
    mov     r0, #0           @ null terminator
    strb    r0, [r5]         @ store null terminator

    // Restore registers and return
    pop     {r4-r7, pc}      @ restore r4-r7 and return

.section .note.GNU-stack,"",%progbits
