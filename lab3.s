.data
@Space to store adresses
@Output Strings
get_addr1: .asciz "Enter address (1/2) as source address. "
get_addr2: .asciz "Enter address (1/2) as destination address. "
get_len: .asciz "Enter the length.\n"
val_addr1: .asciz "Address 1: "
val_addr2: .asciz "Address 2: "
complete: .asciz "\nOperation complete.\n"
addr1: .asciz "this is first string\n"
addr2: .asciz "second one\n"

@Input data
i_format: .asciz "%d"
s_format: .asciz "%s"
.align 4
len: .word 0
in_num1: .word 0
in_num2: .word 0

.text
.global _start

_start:
/*
 @place string1 into addr1
  ldr r4, =addr1
  ldr r5, =string1
  ldr r7, [r4]
  str r7, [r5]
 @place string2 into addr2
  ldr r4, =addr2
  ldr r5, =string2
  ldr r9, [r4]
  str r9, [r5]
 @print value of addr1
  ldr r1, [r5]
  ldr r0, =val_addr1
  bl printf
 @print value of addr2
  ldr r1, [r8]
  ldr r0, =val_addr2
  bl printf
*/

 @print the values of the addresses
  ldr r0, =addr1
  bl printf
  ldr r0, =addr2
  bl printf
 @Prompt user to enter source address
  ldr r0, =get_addr1
  bl printf
 @scan address into addr1
  ldr r0, =i_format
  ldr r1, =in_num1
  bl scanf
  ldr r1, =in_num1
  ldr r5, [r1]
 @Prompt user to enter address 2
  ldr r0, =get_addr2
  bl printf
 @scan address into addr2
  ldr r0, =i_format
  ldr r1, =in_num2
  bl scanf
  ldr r1, =in_num2
  ldr r6, [r1]

 @prompt user to enter length
  ldr r0, =get_len
  bl printf
 @scan length into len
  ldr r0, =i_format
  ldr r1, =len
  bl scanf
  ldr r1, =len
  ldr r2, [r1]
  cmp r2, #0
  ble end
  b validSrc


validSrc:
 @validate input
  cmp r5, #1
  blt end
  beq srcR1
  cmp r5, #2
  bgt end
  beq srcR2

srcR1:
 @load address 1
  ldr r0, =addr1
  b validDest

srcR2:
 @load address 2
  ldr r0, =addr2
  b validDest


validDest:
 @validate input
  cmp r6, #1
  blt end
  beq destR1
  cmp r6, #2
  bgt end
  beq destR2
  
destR1:
 @load address 1
  ldr r1, =addr1
  b copy

destR2:
 @load address 2
  ldr r1, =addr2
  b copy

copy:
  ldrb r3, [r0], #1
  strb r3, [r1], #1
  sub r2, #1
  cmp r2, #0
  bne copy

compl:
 @print the values of the addresses
  ldr r0, =complete
  bl printf
  ldr r0, =addr1
  bl printf
  ldr r0, =addr2
  bl printf

@End of program
end:
  mov r7, #1
  svc 0
