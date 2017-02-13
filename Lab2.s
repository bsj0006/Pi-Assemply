/*--Store Data Here--*/
.data

.balign 4
inputPattern:
  .asciz "%s"

.balign 4
listing:
  .asciz "Welcome to All Time Teller Machine!\nAll sodas cost 55 cents.\n" 

.balign 4
invalid: 
  .asciz "You entered an invalid selection.\n"

.balign 4
getchange:
  .asciz "Insert change or select Return.\n"

.balign 4
saytotal:
  .asciz "\nYour current total is %d\n"
  
.balign 4
getdrink:
  .asciz "Choose Coke(C), Sprite(S), Dr. Pepper(P), Diet Coke(D), Mellow Yellow(M), or return change(R)"

  
  

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
	@Store requested amount in r7
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
	@Print amount in r12 or 10 dollar upcounter
	@Print Thank you and have a great day
	@branch to askTransaction
	b askTransaction


endDay:
	@End program
	MOV r7, #1
	SVC 0






















 /* Current change = 0 */
 mov r5, #0

 /* Coke Amount */
 mov r6, #1
 /* Sprite Amount */
 mov r7, #2
 /* Dr. Pepper Amount */
 mov r8, #1
 /* Diet Coke Amount */
 mov r9, #1
 /* Mellow Yellow Amount */
 mov r10, #1

 /*---Here's the initial price listing----*/
 prices:
   ldr r0, =listing
   bl printf
   b changefirst

 /*---Ask user for change---*/
 changefirst: 
   ldr r0, =getchange
   bl printf
   b inputchange

 /*---Get change amount from user---*/
 inputchange:
   ldr r0, =inputPattern /* Setup to read in one character */
   sub sp, sp, #4
   mov r1, sp
   bl scanf
   ldr r3, [sp, #0] /* This is where the character will be stored */
   add sp, sp, #4
   b caseDb

 /*---List change amount and beg for more---*/
 changemore:
   ldr r0, =saytotal
   mov r1, r5
   bl printf 
   ldr r0, =getchange
   bl printf
   b inputchange

 /*---See if change is greater than price---*/
 cmpchange:
   cmp r5, #55
   bge asksoda
   b changemore

 /*---Ask for soda type---*/
 asksoda:
   ldr r0, =getdrink 
   bl printf

 /*---Check soda input---*/
 inputsoda:
   ldr r0, =inputPattern /* Setup to read in one character */
   sub sp, sp, #4
   mov r1, sp
   bl scanf
   ldr r3, [sp, #0] /* This is where the character will be stored */
   add sp, sp, #4
   b caseCo
   
 /*Dispense Change---*/
 outputchange:
 mov r5, #0
 b prices

/*---Go back to bevarge listing---*/

caseDb:
cmp r3, #66
bne caseQu
add r5, r5, #100
b cmpchange

caseQu:
cmp r3, #81
bne caseDi
add r5, r5, #25
b cmpchange

caseDi:
cmp r3, #68
bne caseNi
add r5, r5, #10
b cmpchange

caseNi:
cmp r3, #78
bne caseReturnA
add r5, r5, #5
b cmpchange

caseReturnA:
cmp r3, #82
bne caseInvalidA
b outputchange

caseInvalidA:
ldr r0, =invalid
bl printf
b changemore

caseCo:
cmp r3, #67
bne caseSp
cmp r6, #0
beq caseEm
sub r5, r5 #55
ldr r0, =giveCo
bl printf
b outputchange


caseSp:
cmp r3, #83
bne caseDp
cmp r7, #0
beq caseEm
sub r5, r5 #55
ldr r0, =giveSp
bl printf
b outputchange


caseDp:
cmp r3, #80
bne caseDc
cmp r8, #0
beq caseEm
sub r5, r5 #55
ldr r0, =giveDp
bl printf
b outputchange


caseDc:
cmp r3, #68
bne caseMy
cmp r9, #0
beq caseEm
sub r5, r5 #55
ldr r0, =giveDc
bl printf
b outputchange


caseMy:
cmp r3, #677
bne caseReturnB
cmp r10, #0
beq caseEm
sub r5, r5 #55
ldr r0, =giveMy
bl printf
b outputchange

/*--Out of that soda--*/
caseEm:
ldr r0, =noSoda
bl printf
b asksoda

/*--Check for return input--*/
caseReturnB:
cmp r3, #82
bne caseInvalidA
b outputchange

caseInvalidB:
ldr r0, =invalid
bl printf
b asksoda

 /*---End the program---*/
stop:
  bx lr


 