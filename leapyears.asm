/* leapyears01.s */
.data
.balign 4
isleapyear:
	.asciz	"%d is a leap year.\n"

.balign 4
notleapyear:
	.asciz	"%d in not a leap year.\n"

.balign 4
yeartotest:
	.word	0

.balign 4
scanpattern:
	.asciz	"%d"

.balign 4
inputmsg:
	.asciz	"Year to test (> 1752): "

.balign 4
yearok:
	.asciz	"Year OK\n"

.balign 4
yeartooearly:
	.asciz	"Year too early.\n"

.global scanf
.global printf
.global main

.text
main:
	ldr r0, =inputmsg		@ Load the input message for printf call
	bl printf			@ Call printf.  No variables in print statement so only r0 is needed

	ldr r0, =scanpattern		@ Load the scan pattern
	ldr r1, =yeartotest		@ Load the mem location for the users input
	bl scanf			@ Get user input

	ldr r0, =yeartotest		@ Load r0 with address of test year
	ldr r0, [r0]			@ Load r0 with the value of test year
	mov r1, #1752			@ Load r1 with 1752, the first leap year.  No leap years before 1752
	cmp r0, r1			@ If r1 > r0 ...
	bmi tooearly			@ ... jump to tooearly then exit
	ldr r0, =yearok			@ Otherwise load r0 with OK message
	bl printf			@ Print OK message

check4:					@ Check divisible by 4
	ldr r0, =yeartotest		@ Load r0 with address of test year
	ldr r0, [r0]			@ Load r0 with value of test year
	mov r1, #4			@ Load r1 with value 4 (mov is faster than ldr)
loop4:
	sub r0, r0, r1			@ r0 = r0 - r1
	bmi notleap			@ if result has gone neg then test year is not divisible by 4 so not leap
	cmp r0, #0			@ Check to see if test year is exactly divisible by 4 (no remainder)
	beq check100			@ If no remainder continue to check for 100 as factor
	b loop4				@ Continue with subtraction as division

check100:				@ Check divisible by 100
	ldr r0, =yeartotest		@ Load r0 with address of test year
	ldr r0, [r0]			@ Load r0 with value of test year
	mov r1, #100			@ Load r1 with value 100 (mov is faster than ldr)
loop100:
	sub r0, r0, r1			@ r0 = r0 - r1
	bmi isleap			@ If test year is divisible by 4 but not by 100 then is leap
	cmp r0, #0			@ If test year is divisible by 4 and by 100 it may be leap
	beq check400			@ Finally check if divisible by 400
	b loop100			@ Continue with subtraction as division

check400:				@ Check if divisible by 400
	ldr r0, =yeartotest		@ Load r0 with address of test year
	ldr r0, [r0]			@ Load r0 with value of test year
	mov r1, #400			@ Load r1 with value 400 (mov is faster than ldr)
loop400:
	sub r0, r0, r1			@ r0 = r0 - r1
	bmi notleap			@ If test year is divisble by 4, 100 but not 400 is not leap
	cmp r0, #0			@ Check if exactly divisible by 400
	beq isleap			@ If test year is divisible by 4, 100 and 400 is leap
	b loop400			@ Continue with subtraction as division

tooearly:				@ Test year prior to 1752
	ldr r0, =yeartooearly		@ Load r0 with too early message
	bl printf			@ Print too early message.  No other variable so only r0 needed 
	b end				@ Jump to end

notleap:				@ Not leap message
	ldr r0, =notleapyear		@ Load r0 with not leap year message (NB contains a variable)
	ldr r1, =yeartotest		@ Load r1 with address of test year
	ldr r1, [r1]			@ Load r1 with value of test year
	bl printf			@ Print message
	b end				@ Jump to end

isleap:					@ Is leap message
	ldr r0, =isleapyear		@ Load r0 with leap year message (NB contains a variable)
	ldr r1, =yeartotest		@ Load r1 with address of test year
	ldr r1, [r1]			@ Load r1 with value of test year
	bl printf			@ Print message
	b end				@ Jump to end
end:
	mov r7, #1			@ Load r7 with exit code
	svc 0				@ call syscall (0 not used)
