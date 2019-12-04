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
ary_addr: .word 0
ary_size: .word 0
src_num: .word 0
msg: .asciz "\nEnter numbers in array:\n"
size: .asciz "\nEnter a number of elements in Array:"
src: .asciz "\nEnter a number tobe search:"
mry: .asciz "\nMemory allocated in Heap at:"
ele: .asciz " Element: "
mtcf: .asciz " \nMatch found Location: "
mtcnf: .asciz " \nMatch not found: "
.global _start
.text
_start:
	ldr r1, =size 	@ load address of Size label
	bl Print_str	@ print "\nEnter a number of elements in Array:"
	
	bl Scan_int		@ scan array size from stdin
	ldr r1,=ary_size  @ Address to store array size
	str r0, [r1]	@ store array size 
	mov r4, r0		@ store array size in r4 for reference 
	
	lsl r0, #2		@ Array size* 4 for memory allocation
	swi SWI_MeAlloc	@ Allocate memory in heap for array, r0 contain address of array in heap
	ldr r1,=ary_addr  @ Address to store array address
	str r0, [r1]	@ store array size 
	mov r3, r0		@ address of Array in Heap
	
	ldr r1, =mry 	@ load address of mry label
	bl Print_str	@ print "\nMemory allocated in Heap at:"
	
	mov r1, r3		@ mov address location to r1
	bl Print_int	@ print array address
	
	ldr r1, =msg 	@ load address of msg label
	bl Print_str	@ print "\nEnter numbers in array:"
	
	mov r2,#0		@ initialize r2 to 0 for counter
	
LOOP:
	mov r1, r2		@ move counter to r1 for printing
	bl Print_int	@ print array index
	
	ldr r1, =ele 	@ load address of ele label
	bl Print_str	@ print "\nElement"
	
	bl Scan_int		@scan number from stdin
	str r0, [r3, r2, lsl #2]	@ store number in to array
	
	add r2, r2, #1	@ increment counter
	cmp r2, r4		@ compare counter with array size
	bne LOOP		@ if not equal loop to take next element

	ldr r1, =src 	@ load address of src label
	bl Print_str	@ print "\nEnter a number tobe search:"
	
	bl Scan_int		@scan number to be searched from stdin
	ldr r1,=src_num  @ Address to store search number
	str r0, [r1]	@ store array size 
	
	bl Find			@ branch to find the number in the array
	b EXIT
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
Find:
	stmdb sp!, {lr} 	@ push lr to stack
	ldr r1, =ary_addr	@ load ary_addr address to r1
	ldr r3, [r1]		@ load ary_addr value in to r3
	ldr r1, =ary_size	@ load ary_size address to r1
	ldr r4, [r1]        @ load ary_size value in to r3
	ldr r1, =src_num	@ load src_num address to r1
	ldr r5, [r1]        @ load src_num value in to r3
	mov r6, #0			@ initialize r6 to 0
search:
	ldr r1, [r3, r6, lsl #2]	@ r1 = [r3 + r6*4] read each element from memory
	cmp r1, r5					@ compare with search element
	mov r2, r6					@ update search location
	beq Matchfound				@ if compare tell equal, brach to Matchfound
	add r6, r6, #1				@ else increment counter
	cmp r4, r6					@ compare counter with array size, if array limit reached
	bne search					@ if not reached check for next array element
	bl Notfound 				@ if we check complet array. brach to Notfound
	ldm sp!, {lr}				@ pop lr from stack
	bx lr						@ branch to lr
Matchfound:
	stmdb sp!, {lr}	@ push lr to stack
	ldr r1, =mtcf 	@ load address of mtcf label
	bl Print_str	@ print " \nMatch found Location: "
	                
	add r2,r2, #1   @ array index to absolute location
	mov r1, r2      @ load data to print
	bl Print_int    @ print match location
	ldm sp!, {lr}   @ pop lr from stack
	bx lr           @ branch to lr
Notfound:           
	stmdb sp!, {lr} @ push lr to stack
	ldr r1, =mtcnf 	@ load address of mtcnf label
	bl Print_str    @ print " \nMatch not found: "
	                
	mov r1, #-1     @ load data to print
	bl Print_int    @ print match location
	ldm sp!, {lr}   @ pop lr from stack
	bx lr           @ branch to lr
EXIT:               
	swi SWI_DAlloc  @Dallocate memory assigned in heap
	swi SWI_Exit    @halt
.end
