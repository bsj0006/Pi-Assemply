@Code Section
.text
.global _start

@Initialize variables at start of day
_start:

	@20 dollar total count r8 = 50
	MOV r8, #50
	@10 dollar total count r9 = 50
	MOV r9, #50
	@customer count r10 = 11
	MOV r10, #10


askTransaction:

	@if customer count is 0, branch to end
	cmp r10, #0
	beq endDay

	@decrement count
	SUB r10, r10, #1
	@20 dollar upcounter r11 = 0
	MOV r11, #0
	@10 dollar upcounter r5 = 0
	MOV r5, #0
	@amount requested r7 = 0
	MOV r7, #0

	@Ask user to input desired amount of money
    	ldr r0, =welcome
    	BL printf
    
	@Store requested amount in r7
    	LDR r0, =input_format
    	LDR r1, =intval
    	BL scanf
    	ldr r7, =intval
	LDR r7, [r7]

	@Check if request is greater than 200
	cmp r7, #200
	bgt errorOver
	
	@switch to upcountTW
	cmp r7, #20
	bge upcountTW
	b upcountTE

upcountTW:
	cmp r8, #0
	ble upcountTE
	@decrement r8 or 20 dollar total
	sub r8, r8, #1
	@increment r11 or 20 dollar upcounter
	add r11, r11, #1
	@subtract 20 from r7 or requested
	sub r7, r7, #20

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
	b errorWrong


upcountTE:
	@if no more tens branch error: Ran out of cash
	cmp r9, #0
	ble errorCash
	@decrement r9 or 10 dollar total
	sub r9, r9, #1
	@increment r5 or 10 dollar upcounter
	add r5, r5, #1
	@subtract 10 from r7 or requested
	sub r7, r7, #10

	@branch back to upcountTE if r7 GTE 10
	cmp r7, #10
	bge upcountTE
	@branch to deposit if r7 equals 0
	cmp r7, #0
	beq deposit
	@branch error: Invalid request amount
	b errorWrong

@Not enough bills
errorCash:
	@Print processing error
	ldr r0, =errorBill
	bl printf
	@Add upcounters back to total counts
	ADD r8, r8, r11
	ADD r9, r9, r5
	@branch to AskTransaction
	b askTransaction

@Asked for amount not in 20s and 10s
errorWrong:
	@Print processing error
	ldr r0, =errorInval
	bl printf
	@Add upcounters back to total counts
	ADD r8, r8, r11
	ADD r9, r9, r5
	@branch to AskTransaction
	b askTransaction

@Asked over $200 limit
errorOver:
	ldr r0, =errorBig
	bl printf
	b askTransaction
	

deposit:
	@Print amount in r11 or 20 dollar upcounter
	mov r1, r11
	ldr r0, =twenties
   	BL printf
	@Print amount in r5 or 10 dollar upcounter
    	mov r1, r5
    	ldr r0, =tens
    	BL printf
	@Print Thank you and have a great day
    	ldr r0, =audios
    	BL printf
	@branch to askTransaction
	b askTransaction


endDay:
	@End program
	MOV r7, #1
	SVC 0

/*--Store Data Here--*/
.data
	welcome: .asciz "Welcome to the All Time Teller Machine\nEnter the amount to withdraw.\n"
	errorInval: .asciz "Invalid request. Please try a different amount.\n\n"
	errorBill: .asciz "Not enough bills. Please try a different amount.\n\n"
	errorBig: .asciz "$200 Limit. Please try a different amount.\n\n"
	twenties: .asciz "Dispensing %d twenty dollar bills.\n" 
	tens: .asciz "Dispensing %d ten dollar bills.\n" 
	audios: .asciz "Thank you for you transaction.\nGoodbye.\n\n\n"
	input_format: .asciz "%d"

    	.align 4
    	@ Set aside space for an integer
    	intval: .word 0
