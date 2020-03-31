.thumb
.syntax unified
.cpu cortex-m4
#define SEMIHOSTING_SYS_WRITE0  #0x04
#define SEMIHOSTING #0xAB

.section .data
    str_hex: .asciz "0xXXXXXXXX\n"

.text
.global dbgput_line
.global dbgput
.global newline
.global dbgput_num
// param: @str
dbgput:
    push {lr}
    // move str to r1
    mov r1, r0
    mov r0, SEMIHOSTING_SYS_WRITE0  
    bkpt SEMIHOSTING
    pop {pc}

_newline_sym: .asciz "\n\r"
.align 4
dbgput_line:
    push {lr}
    // move str to r1
    mov r1, r0
    mov r0, SEMIHOSTING_SYS_WRITE0  
    bkpt SEMIHOSTING
    ldr r1,=_newline_sym
    mov r0, SEMIHOSTING_SYS_WRITE0  
    bkpt SEMIHOSTING
    pop {pc}
newline:
    push {lr}
    ldr r1,=_newline_sym
    mov r0, SEMIHOSTING_SYS_WRITE0  
    bkpt SEMIHOSTING
    pop {pc}
dbgput_num:
    push {lr}
    mov r2, #9
    mov r3, #0x0000000F
    ldr r1, =str_hex
    next:
        push {r0}
        and r0, r3
        add r0, #48
        cmp r0, #58
        blo store
        add r0, #7
    store:
        strb r0, [r1, r2]
        pop {r0}
        lsr r0, r0, #4
        sub r2, #1
        cmp r2, #2
        bge next
        
        ldr r1, =str_hex
        mov r0, SEMIHOSTING_SYS_WRITE0 
        bkpt SEMIHOSTING
        pop {pc}
