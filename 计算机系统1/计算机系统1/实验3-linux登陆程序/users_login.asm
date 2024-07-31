.orig x3000

ld r1,InputAddress
lea r0,prompt1
puts




SaveAccountLoop getc
out
str r0,r1,#0
add r1,r1,#1
add r0,r0,#-10
brnp SaveAccountLoop
add r1,r1,#-1
str r0,r1,#0





add r1,r1,#1
lea r0,prompt2
puts


SavePasswordLoop getc
out
add r0,r0,#-12
str r0,r1,#0
add r1,r1,#1
add r0,r0,#2
brnp SavePasswordLoop
add r1,r1,#-1
str r0,r1,#0


ld r2,UserAddress

add r2,r2,#-1

Recompare add r2,r2,#1
ld r1,InputAddress

ldr r6,r2,#0
brz FailLogin

and r5,r5,#0
add r5,r5,#2
LoopCheck ldr r3,r6,#0
ldr r4,r1,#0



not r4,r4
add r4,r4,#1
add r3,r4,r3
brnp Recompare
add r4,r4,#0
brnp NotX0
add r5,r5,#-1
NotX0 add r1,r1,#1
add r6,r6,#1
add r5,r5,#0
brz SuccessLogin
br LoopCheck



SuccessLogin ldr r6,r2,#0
Printname ldr r0,r6,#0
brz Outprompt
out
add r6,r6,#1
br Printname
Outprompt lea r0,prompt3
puts

halt

FailLogin lea r0,prompt4
puts

halt
prompt1 .stringz "Login ID:"
InputAddress .fill x3500
UserAddress .FILL x4000
prompt2 .stringz "Password:"
prompt3 .stringz ", you have successfully logged in. "
prompt4 .stringz "Invalid UserID/Password. Your login failed. "
.end