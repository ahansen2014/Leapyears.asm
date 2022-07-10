# Leapyears.asm
Implementation of the leap year algorithm in ARM assembly

The leap year algorithm is often used in CS classes as a simple use of IF statements.  The basic algorithm is:
if (year is not divisible by 4) then (it is a common year)
else if (year is not divisible by 100) then (it is a leap year)
else if (year is not divisible by 400) then (it is a common year)
else (it is a leap year)

The difficulty here is that with assembly there is no simple division call so the division process is done using a series of subtractions testing for a result of zero (exact division) or negative result (indicating a remainder exists).
