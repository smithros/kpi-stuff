.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

// Global memory locations.
.global vtable
.global __hard_reset__

/*
 * vector table 
 */
.type vtable, %object
.type __hard_reset__, %function
.section .interrupt_vector
vtable:
    .word __stack_start 
    .word __hard_reset__+1
    .size vtable, .-vtable
.section .text
__hard_reset__:
// initialize stack here
// if not initialized yet
    .data
    d: .asciz "starting \n"
    .text
    ldr r0, =d
    bl dbgput_line
    bl bootload
    _loop: b _loop
    .size __hard_reset__, .-__hard_reset__
