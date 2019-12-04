/******************************************************************************
* file: part_1.s (Sub Routines)
* author: Venkatesh Ravipati
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
@@OPEN INPUT FILE, READ INTEGER FROM FILE, PRINT IT, CLOSE INPUT FILE
.equ SWI_PrChr, 0x00 @ Display Character on Console
.equ SWI_PrStr, 0x02 @ Display String on Console
.equ SWI_Open,  0x66 @ open a file
.equ SWI_Close, 0x68 @ close a file
.equ SWI_WrStr, 0x69 @ Write string to file
.equ SWI_RdStr, 0x6a @ Read string from file
.equ SWI_WrInt, 0x6b @ Write an Integer to file
.equ SWI_RdInt, 0x6c @ Read an Integer from a file

.equ SWI_Exit, 	0x11 @ Stop execution
.equ SWI_MeAlloc, 0x12 @ Allocate Block of Memory on Heap
.equ SWI_DAlloc, 0x13  @ Deallocate All Heap Blocks 

.equ Stdin,		0x0  @ 0 is file descriptor for STDIN
.equ Stdout,    0x1  @ Set output target to be Stdout

.data @ Data section
num: .word 0
msg: .asciz "\nEnter valve of N for Nth Fibonacci numbers:"
msg2: .asciz "\nNth Fibonacci numbers is:"

.global _start
.text
_start:
	ldr r1, =msg 	@ load address of msg label
	bl Print_str	@ print "\nEnter valve of N for Nth Fibonacci numbers:"
	
	bl Scan_int		@ scan N value from stdin
	ldr r1,=num  	@ Address to store N value
	str r0, [r1]	@ store N value 
	
	bl Fibonacci	@argument to the subroutine will go from r0
	ldr r1, =msg2 	@ load address of msg2 label
	bl Print_str    @ print "\nNth Fibonacci numbers is:"
	                
	mov r1, r3     	@ load data to print	
	bl Print_int    @ print match location
	b EXIT

Fibonacci:
	stmdb sp!, {r0-r2,lr}	@ push r0-r2 and lr to stack
	cmp r0, #1				@ check if n = 1 
	beq Return_1			@ if 1 return 1
	cmp r0, #2				@ check if n = 2
	beq Return_1			@ if 2 return 1
	sub r0, r0, #1			@ (n-1)
	bl Fibonacci			@ f(n-1)
	mov r2, r3				@ r2 = f(n-1)
	sub r0, r0, #1			@ (n-1)-1
	bl Fibonacci			@ f(n-2)
	add r3, r3, r2			@ add f(n-1) and f(n-2)
	ldm sp!, {r0-r2,lr}		@ pop r0-r2 and lr from stack
	bx lr					@ branch to lr 
	
Return_1:
	mov r3, #1		@ r1 carry return value
	ldm sp!, {r0-r2,lr}
	bx lr
	
Print_str:
	mov r0,#Stdout 	@ set mode to print message
	swi SWI_WrStr 	@ display message to Stdout
	bx lr
Print_int:
	mov r0,#Stdout 	@ set mode to print message
	swi SWI_WrInt	@ display integer to Stdout
	bx lr
Scan_int:
	mov r0,#Stdin 	@ set mode to take input from stdin
	swi SWI_RdInt	@ read the array from stdin, available in r0
	bx lr

EXIT:               
	swi SWI_DAlloc  @Dallocate memory assigned in heap
	swi SWI_Exit    @halt
.end
