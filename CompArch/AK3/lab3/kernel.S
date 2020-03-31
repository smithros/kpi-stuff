.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define A #1
#define B #3
#define C #4

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start 
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #4: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    
// calculate 
    mov r0, A

    mov r1, B

    mov r2, C

    add r4, r0, r1

    lsr r4, r4, #1
    mov r3, #1
   
fact:
    cmp r2, #1
    beq sum
    mul r3, r2
    sub r2, #1
    b fact

sum:
    add r4, r3
        
    ldr r0, =final
    bl dbgput
    mov r0, r4
    bl dbgput_num
    
    end:
    b end

