@ yesNo2.s
@ Prompts user to enter a y/n response.
@ 2024-08-11: JJ Hoffmann

@ Define my Raspberry Pi
        .arch armv7-a
        .cpu cortex-a72
        .fpu neon-fp-armv8
        .syntax unified         @ modern syntax

@ Useful source code constants
        .equ    STDOUT,1
        .equ    STDIN,0
        .equ    NUL,0
        .equ    response,-20
        .equ    local,8

@ Constant program data
        .section  .rodata
        .align  2
prompt:
        .asciz  "Save changes? "
        .align  2
yes:
        .asciz  "Changes saved.\n"
        .align  2
no:
        .asciz  "Changes discarded.\n"

@ The program
        .text
        .align  2
        .global main
        .type   main, %function
main:
        sub     sp, sp, 16      @ space for saving regs
                                @ (keeping 8-byte sp align)
        str     r4, [sp, 4]     @ save r4
        str     fp, [sp, 8]     @      fp
        str     lr, [sp, 12]    @      lr
        add     fp, sp, 12      @ set our frame pointer
        sub     sp, sp, local   @ local variable

        ldr     r4, promptAddr  @ prompt user
promptLoop:
        ldrb    r3, [r4]        @ get a char
        cmp     r3, NUL         @ end of string?
        beq     getResponse     @ yes, get response

        mov     r0, STDOUT      @ no, write to screen
        mov     r1, r4          @ address of current char
        mov     r2, 1           @ write 1 byte
        bl      write

        add     r4, r4, 1       @ increment pointer var
        b       promptLoop      @ back to top

getResponse:
        mov     r0, STDIN       @ from keyboard
        add     r1, fp, response   @ address of response
        mov     r2, 1           @ one char
        bl      read
        
        ldrb    r3, [fp, response] @ load response
        cmp     r3, 'y          @ was it 'y'?
        bne     discard         @ no, discard changes

        ldr     r4, yesAddr     @ "Changes saved."
yesLoop:
        ldrb    r3, [r4]        @ get a char
        cmp     r3, NUL         @ end of string?
        beq     endThen         @ yes, end of then block
        mov     r0, STDOUT      @ no, write to screen
        mov     r1, r4          @ address of current char
        mov     r2, 1           @ write 1 byte
        bl      write
        add     r4, r4, 1       @ increment pointer var
        b       yesLoop         @ back to top
endThen:
        b       endElse         @ branch over else block

discard:
        ldr     r4, noAddr      @ "Changes discarded."
noLoop:
        ldrb    r3, [r4]        @ get a char
        cmp     r3, NUL         @ end of string?
        beq     endElse         @ yes, end of if-else
        mov     r0, STDOUT      @ no, write to screen
        mov     r1, r4          @ address of current char
        mov     r2, 1           @ write 1 byte
        bl      write
        add     r4, r4, 1       @ increment pointer var
        b       noLoop          @ back to top

endElse:
        bl      clearInputBuffer @ clear the input buffer
        mov     r0, 0           @ return 0;
        add     sp, sp, local   @ deallocate local var
        ldr     r4, [sp, 4]     @ restore r4
        ldr     fp, [sp, 8]     @         fp
        ldr     lr, [sp, 12]    @         lr
        add     sp, sp, 16      @         sp
        bx      lr              @ return

clearInputBuffer:
        mov     r0, STDIN       @ file descriptor for stdin
clearLoop:
        mov     r1, sp          @ buffer to store the character
        mov     r2, 1           @ read 1 byte
        mov     r7, #3          @ syscall number for sys_read
        svc     0               @ make the syscall
        cmp     r0, #0          @ check if EOF
        beq     clearDone       @ if EOF, exit loop
        ldrb    r3, [sp]        @ load the character
        cmp     r3, #10         @ check if newline (ASCII 10)
        bne     clearLoop       @ if not newline, continue loop
clearDone:
        bx      lr              @ return from subroutine

        .align        2
promptAddr:
        .word   prompt
yesAddr:
        .word   yes
noAddr:
        .word   no

.section .note.GNU-stack,"",%progbits
