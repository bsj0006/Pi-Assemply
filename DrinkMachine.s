/*--Store Data Here--*/
.data

.balign 4
inputPattern:
  .asciz "%s"

.balign 4
listing:
  .asciz "Welcome to the Soda Machine!\nAll sodas cost 55 cents.\n" 

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

.balign 4
giveCo:
  .asciz "Enjoy your coke"

.balign 4
giveSp:
  .asciz "Enjoy your sprite"

.balign 4
giveDp:
  .asciz "Enjoy your dr. Pepper"

.balign 4
giveDc:
  .asciz "Enjoy your diet coke"

.balign 4
giveMy:
  .asciz "Enjoy your mellow yellow"

.balign 4
noSoda:
  .asciz "Out of that soda."
  
  

/*----Here's the code---*/
.text
.global main

/*---Here's the main loop where price is set, and drink amount is set----*/
main:

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


 
