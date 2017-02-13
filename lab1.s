.text @code section
.global main 

main: /* Program entry point */
	
	/* r9 ocounter */
	/* r10 ecounter */
	/* r11 even */
	/* r12 odd */
	@set up stack
	LDR sp, =stack
	ADD sp, sp, #100
	mov r9, #-1
	mov r10, #0
	mov r11, #0
	mov r12, #0
	
	/*Return from main */

evenwhile:
	add r10, r10, #2
	add r11, r11, r10
	mov r1, r10
	bl outDec
	bl newLine
	cmp r10, #24
	blt evenwhile

oddwhile:

	add r9, r9, #2
	add r12, r12, r9
	mov r1, r9
	bl outDec
	bl newLine
	cmp r9, #25
	blt oddwhile
sum:
	MOV R7, #0x04	@ doing a write
	MOV R0, #0x01 	@ writing to standard out
	MOV R2, #0x6	@ length of string
	LDR R1, =even	@ put address of string in R1
	SVC 0		@ do the system call
	mov r1, r11
	bl outDec
	bl newLine

	MOV R7, #0x04	@ doing a write
	MOV R0, #0x01 	@ writing to standard out
	MOV R2, #0x5	@ length of string
	LDR R1, =odd	@ put address of string in R1
	SVC 0		@ do the system call
	mov r1, r12
	bl outDec
	bl newLine

	add r11, r11, r12
	MOV R7, #0x04	@ doing a write
	MOV R0, #0x01 	@ writing to standard out
	MOV R2, #0x5	@ length of string
	LDR R1, =summ	@ put address of string in R1
	SVC 0		@ do the system call
	mov r1, r11
	bl outDec
	bl newLine
	@ exit the program
	MOV r7, #1
	SVC 0

outDec:   @ This routine expects the number to be printed to be in r1
	PUSH  {r0-r4, r6, r8, lr}     @ save working registers & link register
	MOV   r8, #0
	MOV   r4, #0                  @ number of digits in number to print

outNext:  
	MOV   r8, r8, LSL #4
	ADD   r4, r4, #1
	BL    div10                   @ quotient will be in r1 and remainder in r2
	ADD   r8, r8, r2              @ insert remainder (least significant digit)
	CMP   r1, #0                  @ if quotient zero then all done
	BNE   outNext                 @ else deal with the next digit
outNxt1:  
	AND   r0, r8, #0xF
	ADD   r0, r0, #0x30
	LDR   r6, =value
	STR   r0, [r6]                @ copy value in r0 to our storage area (value)
	MOVS  r8, r8, LSR #4
	BL    putCh
	SUBS  r4, r4, #1              @ decrement counter
  	BNE   outNxt1                 @ repeat until all printed          
outEx:    
	POP {r0-r4, r6, r8, pc}       @ restore registers and return (end of outDec)
div10:                                  @ divide r1 by 10
                                        @ return with quotient in r1, remainder in r2      
          SUB   r2, r1, #10
          SUB   r1, r1, r1, LSR #2
          ADD   r1, r1, r1, LSR #4
          ADD   r1, r1, r1, LSR #8
          ADD   r1, r1, r1, LSR #16
          MOV   r1, r1, LSR #3
          ADD   r3, r1, r1, ASL #2
          SUBS  r2, r2, r3, ASL #1
          ADDPL r1, r1, #1
          ADDMI r2, r2, #10
          MOV   pc, lr                  @ exit div10

putCh:    
          PUSH {r0-r2, r7, lr}          @ save working registers

          @ write the value
          MOV   r7, #4                  @ for printing
          MOV   r0, #1                  @ for standard output
          MOV   r2, #1                  @ buffer size
          LDR   r1, =value              @ address of value
          SVC   0                       @ invoke kernel

          POP {r0-r2, r7, pc}           @ exit putCh
newLine:
          @ write a newline
          MOV  R7, #0x04        @ doing a write
          MOV  R0, #0x01        @ file descriptor = standard output
          MOV  R2, #1           @ buffer size (no. bytes to write)
          LDR  R1, =nl          @ put address of message in R1
          SVC  0                @ do the system call

          MOV pc, lr            @ exit newline subroutine

@DATA SECTION
.data
	even: .ascii "Even: "
	odd: .ascii "Odd: "
	summ: .ascii "Sum: "
	value:  .word 0
	stack:  .space 0x100, 0	@ set up stack
	nl:     .ascii "\n"
