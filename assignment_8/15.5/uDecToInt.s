.arch   armv7-a
.cpu    cortex-a53
.fpu    neon-fp-armv8
.syntax unified

.global uDecToInt
.section .text

uDecToInt:
    // Save registers and set up stack frame
    push    {r4, lr}         @ save r4 and lr
    mov     r4, r0           @ save the pointer to the string in r4
    mov     r0, #0           @ initialize result to 0

convert_loop:
    ldrb    r1, [r4], #1     @ load next byte and increment pointer
    cmp     r1, #0           @ check if end of string (null terminator)
    beq     end_convert      @ if end of string, exit loop

    sub     r1, r1, #48      @ convert ASCII to integer (subtract '0')
    cmp     r1, #9           @ check if valid digit (0-9)
    bhi     error            @ if not a valid digit, go to error

    mov     r2, #10          @ move 10 into r2
    mul     r0, r0, r2       @ multiply current result by 10
    add     r0, r0, r1       @ add the new digit to the result
    b       convert_loop     @ repeat the loop

end_convert:
    pop     {r4, pc}         @ restore r4 and return

error:
    mov     r0, #-1          @ return -1 to indicate an error
    pop     {r4, pc}         @ restore r4 and return

.section .note.GNU-stack,"",%progbits
