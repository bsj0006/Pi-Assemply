/*--Store Data Here--*/
.data
    welcome: .asciz "Welcome to the All Time Teller Machine\nEnter the amount to withdraw.\n"
    errorA: .asciz "Cannot complete request. Please try a different amount.\n"
    twenties: .asciz "Dispensing %d twenty dollar bills.\n" 
    tens: .asciz "Dispensing %d ten dollar bills.\n" 
    audios: .asciz "Thank you for you transaction.\nGoodbye.\n\n\n"
    input_format: .asciz "%d"

    .align 4
    @ Set aside space for an integer
    intval: .word 0  


@Code Section
.text
.global startDay

@Initialize variables at start of day
startDay:

	@20 dollar total count r8 = 50
	MOV r8, #50
	@10 dollar total count r9 = 50
	MOV r9, #50
	@customer count r10 = 10
	MOV r10, #10


askTransaction:


	@decrement count
	SUB r10, r10, #1
	@20 dollar upcounter r11 = 0
	MOV r11, #0
	@10 dollar upcounter r12 = 0
	MOV r12, #0
	@amount requested r7 = 0
	MOV r7, #0

	@if customer count is 0, branch to end
	cmp r10, #0
	beq endDay
	@Ask user to input desired amount of money
    ldr r0, =welcome
    bl printf
    
	@Store requested amount in r7
    LDR r0, =input_format
    LDR r1, =intval
    bl scanf
    ldr r7, =intval
	@switch to upcountTW
	b upcountTW

upcountTW:
	@if no more twenties branch error: Ran out of cash
	cmp r8, #0
	ble error
	@decrement r8 or 20 dollar total
	sub r8, r8, #1
	@increment r11 or 20 dollar upcounter
	add r11, r11, #1
	@subtract 20 from r7 or requested
	sub r7, r7 #20

	@branch back to upcountTW if r7 GTE 20
	cmp r7, #20
	bge upcountTW
	@branch to upcountTE if r7 GTE 10
	cmp r7, #10
	bge upcountTE
	@branch to deposit if r7 equals 0
	cmp r7, #0
	beq deposit
	@branch error: Invalid request amount
	b error


upcountTE
	@if no more tens branch error: Ran out of cash
	cmp r9, #0
	ble error
	@decrement r9 or 10 dollar total
	sub r9, r9, #1
	@increment r12 or 10 dollar upcounter
	add r12, r12, #1
	@subtract 10 from r7 or requested
	sub r7, r7, #10

	@branch back to upcountTE if r7 GTE 10
	cmp r7, #10
	bge upcountTE
	@branch to deposit if r7 equals 0
	cmp r7, #0
	beq deposit
	@branch error
	b error: Invalid request amount


error:
	@Print processing error
	@Add upcounters back to total counts
	ADD r8, r8, r11
	ADD r9, r9, r12
	@branch to AskTransaction
	b askTransaction


deposit:
	@Print amount in r11 or 20 dollar upcounter
    ldr r1, [r11]
    ldr r0, =twenties
    bl printf
	@Print amount in r12 or 10 dollar upcounter
    ldr r1, [r12]
    ldr r0, =tens
    bl printf
	@Print Thank you and have a great day
    ldr r0, =audios
    bl printf
	@branch to askTransaction
	b askTransaction


endDay:
	@End program
	MOV r7, #1
	SVC 0
